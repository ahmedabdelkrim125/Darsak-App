import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '../database/app_database.dart';
import '../database/database_provider.dart';
import '../database/local_data_loader.dart';
import '../database/sync_signal.dart';
import '../di/service_locator.dart';
import '../network/error/api_error.dart';
import '../network/models/profile_model.dart';
import '../network/network_info.dart';
import '../notifications/push_service.dart';
import '../session/app_session.dart';
import 'avatar_storage.dart';
import 'sync_mapper.dart';
import 'sync_remote.dart';

enum SyncStatus { idle, syncing, offline, failed }

class SyncEngine extends ChangeNotifier {
  SyncEngine._();

  static final SyncEngine instance = SyncEngine._();

  static const int _pageSize = 500;
  static const int _batchSize = 100;
  static const int _maxAttempts = 3;

  final SyncRemote _remote = SyncRemote();

  SyncStatus _status = SyncStatus.idle;
  int _pending = 0;
  bool _started = false;
  bool _running = false;
  bool _rerun = false;
  Timer? _debounce;
  Timer? _periodic;
  StreamSubscription<bool>? _network;
  AppLifecycleListener? _lifecycle;

  SyncStatus get status => _status;

  int get pending => _pending;

  void start() {
    if (_started) return;
    _started = true;
    SyncSignal.onLocalWrite = requestSync;
    _network = getIt<NetworkInfo>().onChanged.listen((online) {
      if (online) {
        requestSync();
      } else {
        _setStatus(SyncStatus.offline);
      }
    });
    _lifecycle = AppLifecycleListener(onResume: requestSync);
    _periodic = Timer.periodic(
      const Duration(seconds: 90),
      (_) => requestSync(),
    );
  }

  void stop() {
    _started = false;
    SyncSignal.onLocalWrite = null;
    _debounce?.cancel();
    _periodic?.cancel();
    _lifecycle?.dispose();
    _lifecycle = null;
    unawaited(_network?.cancel());
    _network = null;
    _pending = 0;
    _setStatus(SyncStatus.idle);
  }

  void requestSync() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 2), () => unawaited(syncNow()));
  }

  Future<void> flush() async {
    final deadline = DateTime.now().add(const Duration(seconds: 8));
    while (_running && DateTime.now().isBefore(deadline)) {
      await Future<void>.delayed(const Duration(milliseconds: 200));
    }
    try {
      await syncNow().timeout(const Duration(seconds: 8));
    } on Object {
      return;
    }
  }

  Future<void> syncNow() async {
    if (_running) {
      _rerun = true;
      return;
    }
    if (!DatabaseProvider.instance.isOpen) return;
    if (!await getIt<NetworkInfo>().isConnected) {
      _setStatus(SyncStatus.offline);
      return;
    }

    _running = true;
    _setStatus(SyncStatus.syncing);
    try {
      await _push();
      await _pull();
      await _pullProfile();
      await _refreshPending();
      unawaited(PushService.instance.ensureRegistered());
      _setStatus(SyncStatus.idle);
    } on ApiError catch (error) {
      _setStatus(
        error.isConnectionIssue ? SyncStatus.offline : SyncStatus.failed,
      );
      if (kDebugMode) debugPrint('[Sync] ${error.message}');
    } on Object catch (error) {
      _setStatus(SyncStatus.failed);
      if (kDebugMode) debugPrint('[Sync] $error');
    } finally {
      _running = false;
      if (_rerun) {
        _rerun = false;
        requestSync();
      }
    }
  }

  void _setStatus(SyncStatus value) {
    if (_status == value) return;
    _status = value;
    notifyListeners();
  }

  AppDatabase get _db => DatabaseProvider.instance.db;

  String get _userId => DatabaseProvider.instance.userId!;

  Future<void> _refreshPending() async {
    final total = _db.outbox.id.count();
    final count = await (_db.selectOnly(_db.outbox)..addColumns([total]))
        .map((row) => row.read(total) ?? 0)
        .getSingle();
    if (_pending == count) return;
    _pending = count;
    notifyListeners();
  }

  Future<void> _push() async {
    await (_db.update(_db.outbox)..where(
          (t) => t.failed.equals(true) & t.attempts.isSmallerThanValue(_maxAttempts),
        ))
        .write(const OutboxRowCompanion(failed: Value(false)));

    final rows =
        await (_db.select(_db.outbox)
              ..where((t) => t.failed.equals(false))
              ..orderBy([(t) => OrderingTerm.asc(t.id)]))
            .get();
    if (rows.isEmpty) return;

    for (final entity in SyncMapper.entities) {
      final batch = rows.where((row) => row.entity == entity).toList();
      if (batch.isNotEmpty) await _pushEntity(entity, batch);
    }

    final profiles = rows.where((row) => row.entity == 'profiles').toList();
    for (final row in profiles) {
      await _pushProfile(row);
    }
  }

  Future<void> _pushEntity(String entity, List<OutboxRow> rows) async {
    final items = <_PushItem>[];
    for (final row in rows) {
      final map = await SyncMapper.toRemote(_db, entity, row.entityId, _userId);
      if (map == null) {
        await _drop([row.id]);
      } else {
        items.add(_PushItem(row, map));
      }
    }

    for (var start = 0; start < items.length; start += _batchSize) {
      final end = start + _batchSize > items.length
          ? items.length
          : start + _batchSize;
      final chunk = items.sublist(start, end);
      try {
        await _remote.upsert(entity, chunk.map((item) => item.map).toList());
        await _drop(chunk.map((item) => item.row.id).toList());
      } on ApiError catch (error) {
        if (error.isConnectionIssue || error.isSessionIssue) rethrow;
        for (final item in chunk) {
          try {
            await _remote.upsert(entity, [item.map]);
            await _drop([item.row.id]);
          } on ApiError catch (single) {
            if (single.isConnectionIssue || single.isSessionIssue) rethrow;
            await _markFailed(item.row, single.message);
          }
        }
      }
    }
  }

  Future<void> _pushProfile(OutboxRow row) async {
    final payload = row.payload == null
        ? <String, dynamic>{}
        : jsonDecode(row.payload!) as Map<String, dynamic>;
    final fields = <String, dynamic>{
      'full_name': payload['full_name'],
      'subject': payload['subject'],
      'phone': payload['phone'],
      'bio': payload['bio'],
    };

    String? newRemote;
    var avatarTouched = false;
    try {
      if (payload['avatar_changed'] == true) {
        final local = payload['avatar_local'] as String?;
        if (local != null) {
          final file = File(local);
          if (await file.exists()) {
            newRemote =
                '$_userId/avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
            await _remote.uploadAvatar(newRemote, await file.readAsBytes());
            fields['avatar_path'] = newRemote;
            avatarTouched = true;
          }
        } else {
          fields['avatar_path'] = null;
          avatarTouched = true;
        }
      }
      await _remote.patchProfile(_userId, fields);
    } on ApiError catch (error) {
      if (error.isConnectionIssue || error.isSessionIssue) rethrow;
      await _markFailed(row, error.message);
      return;
    }

    if (avatarTouched) {
      final old = AppSession.instance.avatarRemote;
      AppSession.instance.setAvatarRemote(newRemote);
      if (old != null && old != newRemote) {
        unawaited(_remote.deleteAvatar(old).catchError((Object _) {}));
      }
    }
    await _drop([row.id]);
  }

  Future<void> _drop(List<int> ids) async {
    await (_db.delete(_db.outbox)..where((t) => t.id.isIn(ids))).go();
  }

  Future<void> _markFailed(OutboxRow row, String message) async {
    final attempts = row.attempts + 1;
    await (_db.update(_db.outbox)..where((t) => t.id.equals(row.id))).write(
      OutboxRowCompanion(
        attempts: Value(attempts),
        lastError: Value(message),
        failed: Value(attempts >= _maxAttempts),
      ),
    );
  }

  Future<String?> _cursor(String entity) async {
    final row = await (_db.select(
      _db.syncCursors,
    )..where((t) => t.entity.equals(entity))).getSingleOrNull();
    return row?.cursor;
  }

  Future<void> _saveCursor(String entity, String cursor) {
    return _db
        .into(_db.syncCursors)
        .insertOnConflictUpdate(
          SyncCursorRowCompanion(entity: Value(entity), cursor: Value(cursor)),
        );
  }

  String _withOverlap(String cursor) {
    return DateTime.parse(
      cursor,
    ).subtract(const Duration(seconds: 5)).toUtc().toIso8601String();
  }

  Future<void> _pull() async {
    var changed = false;
    for (final entity in SyncMapper.entities) {
      final pendingRows = await (_db.select(
        _db.outbox,
      )..where((t) => t.entity.equals(entity))).get();
      final skip = pendingRows.map((row) => row.entityId).toSet();

      var cursor = await _cursor(entity);
      var first = true;
      while (true) {
        final rows = await _remote.fetch(
          entity,
          cursor: cursor == null
              ? null
              : (first ? _withOverlap(cursor) : cursor),
          limit: _pageSize,
        );
        first = false;
        if (rows.isEmpty) break;
        if (await SyncMapper.apply(_db, entity, rows, skip)) changed = true;
        final last = rows.last['updated_at'];
        if (last is String) {
          cursor = last;
          await _saveCursor(entity, last);
        }
        if (rows.length < _pageSize) break;
      }
    }
    if (changed) await LocalDataLoader.instance.reload();
  }

  Future<void> _pullProfile() async {
    final hasPending = await (_db.select(
      _db.outbox,
    )..where((t) => t.entity.equals('profiles'))).get();
    if (hasPending.isNotEmpty) return;

    final json = await _remote.fetchProfile(_userId);
    if (json == null) return;
    final session = AppSession.instance;
    if (!session.isSignedIn) return;

    session.applyProfile(ProfileModel.fromJson(json));

    final remoteAvatar = json['avatar_path'] as String?;
    if (remoteAvatar == session.avatarRemote) return;
    if (remoteAvatar == null) {
      session.setAvatarFromRemote(null, null);
      return;
    }
    final bytes = await _remote.downloadAvatar(remoteAvatar);
    if (bytes.isEmpty) return;
    final path = await AvatarStorage.saveBytes(bytes, _userId);
    session.setAvatarFromRemote(path, remoteAvatar);
  }
}

class _PushItem {
  const _PushItem(this.row, this.map);

  final OutboxRow row;
  final Map<String, dynamic> map;
}
