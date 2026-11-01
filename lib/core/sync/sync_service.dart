import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '../database/app_database.dart';
import '../database/database_provider.dart';
import '../di/service_locator.dart';
import '../network/network_info.dart';
import '../session/app_session.dart';
import 'entity_sync.dart';
import 'profile_sync.dart';

class SyncService with WidgetsBindingObserver {
  SyncService._();

  static final SyncService instance = SyncService._();

  static const Duration _interval = Duration(seconds: 45);
  static const Duration _debounce = Duration(milliseconds: 1500);

  String? _userId;
  Timer? _periodic;
  Timer? _debounceTimer;
  StreamSubscription<bool>? _connectivity;
  bool _running = false;
  bool _again = false;
  bool _observing = false;

  void start(String userId) {
    if (_userId == userId) {
      nudge();
      return;
    }
    _teardown();
    _userId = userId;
    AppDatabase.onDirty = nudge;
    AppSession.onLocalEdit = _onProfileEdit;
    if (!_observing) {
      WidgetsBinding.instance.addObserver(this);
      _observing = true;
    }
    _connectivity = getIt<NetworkInfo>().onChanged.listen((connected) {
      if (connected) nudge();
    });
    _periodic = Timer.periodic(_interval, (_) => nudge());
    unawaited(_resetFailedThenSync(userId));
  }

  Future<void> stop() async {
    _teardown();
  }

  void _teardown() {
    _userId = null;
    AppDatabase.onDirty = null;
    AppSession.onLocalEdit = null;
    _debounceTimer?.cancel();
    _periodic?.cancel();
    final subscription = _connectivity;
    if (subscription != null) unawaited(subscription.cancel());
    _debounceTimer = null;
    _periodic = null;
    _connectivity = null;
    if (_observing) {
      WidgetsBinding.instance.removeObserver(this);
      _observing = false;
    }
  }

  void nudge() {
    if (_userId == null) return;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounce, () => unawaited(sync()));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) nudge();
  }

  void _onProfileEdit(bool avatarChanged) {
    final userId = _userId;
    if (userId == null) return;
    unawaited(
      ProfileSync(
        getIt<Dio>(),
      ).markDirty(userId, avatar: avatarChanged).then((_) => nudge()),
    );
  }

  Future<void> _resetFailedThenSync(String userId) async {
    try {
      final db = DatabaseProvider.instance.db;
      await EntitySync(getIt<Dio>()).resetFailed(db);
    } on Object catch (error) {
      _log('reset failed: $error');
    }
    if (_userId == userId) await sync();
  }

  Future<void> sync() async {
    final userId = _userId;
    if (userId == null) return;
    if (_running) {
      _again = true;
      return;
    }
    _running = true;
    try {
      if (!await getIt<NetworkInfo>().isConnected) return;
      final dio = getIt<Dio>();
      final entities = EntitySync(dio);
      final profile = ProfileSync(dio);

      await _guard('profile', () => profile.sync(userId), userId);
      await _guard('push', () async {
        await entities.push(DatabaseProvider.instance.db, userId);
      }, userId);
      await _guard('pull', () async {
        await entities.pull(DatabaseProvider.instance.db);
      }, userId);
    } finally {
      _running = false;
      if (_again) {
        _again = false;
        nudge();
      }
    }
  }

  Future<void> _guard(
    String label,
    Future<void> Function() task,
    String userId,
  ) async {
    if (_userId != userId || DatabaseProvider.instance.userId != userId) return;
    try {
      await task();
    } on Object catch (error) {
      _log('$label: $error');
    }
  }

  void _log(String message) {
    if (kDebugMode) debugPrint('[Sync] $message');
  }
}
