import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/models/profile_model.dart';
import '../session/app_session.dart';

class ProfileSync {
  ProfileSync(this._dio);

  final Dio _dio;

  static const int _maxAvatarBytes = 3 * 1024 * 1024;

  AppSession get _session => AppSession.instance;

  String _key(String name, String userId) => 'sync_${name}_$userId';

  Future<void> markDirty(String userId, {required bool avatar}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key('profile_draft', userId),
      jsonEncode({
        'full_name': _session.fullName,
        'phone': _session.phone,
        'bio': _session.bio,
        'subject': _session.subject,
      }),
    );
    await prefs.setBool(_key('profile_dirty', userId), true);
    if (!avatar) return;
    await prefs.setBool(_key('avatar_dirty', userId), true);
    final path = _session.avatarPath;
    if (path == null) {
      await prefs.remove(_key('avatar_local', userId));
    } else {
      await prefs.setString(_key('avatar_local', userId), path);
    }
  }

  Future<void> sync(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final remote = await _fetch(userId);
    if (remote == null) return;
    await _reconcile(prefs, userId, remote);
    if (_isDirty(prefs, userId)) {
      _restoreDraft(prefs, userId);
      await _push(prefs, userId, remote);
    }
    await _pull(prefs, userId);
  }

  bool _isDirty(SharedPreferences prefs, String userId) {
    return prefs.getBool(_key('profile_dirty', userId)) ?? false;
  }

  Map<String, dynamic>? _readDraft(SharedPreferences prefs, String userId) {
    final raw = prefs.getString(_key('profile_draft', userId));
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw);
      return decoded is Map ? Map<String, dynamic>.from(decoded) : null;
    } on FormatException {
      return null;
    }
  }

  void _restoreDraft(SharedPreferences prefs, String userId) {
    final draft = _readDraft(prefs, userId);
    if (draft == null) return;
    _session.applyDraft(
      fullName: draft['full_name'] as String?,
      phone: draft['phone'] as String?,
      bio: draft['bio'] as String?,
      subject: draft['subject'] as String?,
    );
  }

  Future<ProfileModel?> _fetch(String userId) async {
    final response = await _dio.get<List<dynamic>>(
      '/rest/v1/profiles',
      queryParameters: {'id': 'eq.$userId', 'select': '*'},
    );
    final rows = response.data ?? const <dynamic>[];
    if (rows.isEmpty) return null;
    return ProfileModel.fromJson(Map<String, dynamic>.from(rows.first as Map));
  }

  Future<void> _reconcile(
    SharedPreferences prefs,
    String userId,
    ProfileModel remote,
  ) async {
    final marker = _key('reconciled', userId);
    if (prefs.getBool(marker) ?? false) return;
    final differs =
        _session.fullName.trim() != remote.fullName.trim() ||
        _session.phone.trim() != remote.phone.trim() ||
        _session.bio.trim() != remote.bio.trim() ||
        _session.subject.trim() != remote.subject.trim();
    final localAvatar = _session.avatarPath;
    final hasLocalAvatar =
        localAvatar != null &&
        remote.avatarPath == null &&
        File(localAvatar).existsSync();
    if (differs) {
      await prefs.setBool(_key('profile_dirty', userId), true);
      await prefs.setString(
        _key('profile_draft', userId),
        jsonEncode({
          'full_name': _session.fullName,
          'phone': _session.phone,
          'bio': _session.bio,
          'subject': _session.subject,
        }),
      );
    }
    if (hasLocalAvatar) {
      await prefs.setBool(_key('profile_dirty', userId), true);
      await prefs.setBool(_key('avatar_dirty', userId), true);
      await prefs.setString(_key('avatar_local', userId), localAvatar);
    }
    await prefs.setBool(marker, true);
  }

  Future<void> _push(
    SharedPreferences prefs,
    String userId,
    ProfileModel remote,
  ) async {
    final avatarKey = _key('avatar_dirty', userId);
    final remoteKey = _key('avatar_remote', userId);
    var avatarRemote = prefs.getString(remoteKey) ?? remote.avatarPath;
    final draft = _readDraft(prefs, userId);
    final body = <String, dynamic>{
      'full_name': (draft?['full_name'] as String?) ?? _session.fullName,
      'phone': (draft?['phone'] as String?) ?? _session.phone,
      'bio': (draft?['bio'] as String?) ?? _session.bio,
      'subject': (draft?['subject'] as String?) ?? _session.subject,
    };

    if (prefs.getBool(avatarKey) ?? false) {
      final local =
          prefs.getString(_key('avatar_local', userId)) ??
          _session.avatarPath;
      if (local == null) {
        final old = avatarRemote;
        body['avatar_path'] = null;
        avatarRemote = null;
        if (old != null) await _deleteRemote(old);
      } else {
        final uploaded = await _upload(userId, local);
        if (uploaded != null) {
          final old = avatarRemote;
          body['avatar_path'] = uploaded;
          avatarRemote = uploaded;
          if (old != null && old != uploaded) await _deleteRemote(old);
        } else if (kDebugMode) {
          debugPrint('[ProfileSync] avatar skipped: $local');
        }
      }
    }

    await _dio.patch<dynamic>(
      '/rest/v1/profiles',
      queryParameters: {'id': 'eq.$userId'},
      data: body,
      options: Options(headers: {'Prefer': 'return=minimal'}),
    );

    if (avatarRemote == null) {
      await prefs.remove(remoteKey);
    } else {
      await prefs.setString(remoteKey, avatarRemote);
    }
    await prefs.remove(avatarKey);
    await prefs.remove(_key('avatar_local', userId));
    await prefs.remove(_key('profile_draft', userId));
    await prefs.remove(_key('profile_dirty', userId));
  }

  Future<String?> _upload(String userId, String localPath) async {
    final file = File(localPath);
    if (!file.existsSync()) return null;
    final bytes = await file.readAsBytes();
    if (bytes.isEmpty || bytes.length > _maxAvatarBytes) return null;
    final extension = localPath.split('.').last.toLowerCase();
    final mime = switch (extension) {
      'png' => 'image/png',
      'webp' => 'image/webp',
      'jpg' || 'jpeg' => 'image/jpeg',
      _ => null,
    };
    if (mime == null) return null;
    final path =
        '$userId/avatar_${DateTime.now().millisecondsSinceEpoch}.$extension';
    await _dio.post<dynamic>(
      '/storage/v1/object/avatars/$path',
      data: Stream<List<int>>.value(bytes),
      options: Options(
        headers: {
          Headers.contentLengthHeader: bytes.length,
          Headers.contentTypeHeader: mime,
          'x-upsert': 'true',
        },
      ),
    );
    return path;
  }

  Future<void> _deleteRemote(String path) async {
    try {
      await _dio.delete<dynamic>('/storage/v1/object/avatars/$path');
    } on DioException {
      return;
    }
  }

  Future<void> _pull(SharedPreferences prefs, String userId) async {
    if (_isDirty(prefs, userId)) return;
    final remote = await _fetch(userId);
    if (remote == null) return;
    if (_isDirty(prefs, userId)) return;
    _session.applyProfile(remote);

    final remoteKey = _key('avatar_remote', userId);
    final known = prefs.getString(remoteKey);
    final path = remote.avatarPath;
    if (path == known) return;

    if (path == null) {
      _session.applyAvatar(null);
      await prefs.remove(remoteKey);
      return;
    }

    final local = await _download(userId, path);
    if (local == null) return;
    if (_isDirty(prefs, userId)) return;
    final previous = _session.avatarPath;
    _session.applyAvatar(local);
    await prefs.setString(remoteKey, path);
    if (previous != null && previous != local && previous.contains('avatar_')) {
      final old = File(previous);
      if (old.existsSync()) await old.delete();
    }
  }

  Future<String?> _download(String userId, String path) async {
    final response = await _dio.get<List<int>>(
      '/storage/v1/object/authenticated/avatars/$path',
      options: Options(responseType: ResponseType.bytes),
    );
    final bytes = response.data;
    if (bytes == null || bytes.isEmpty) return null;
    final directory = await getApplicationDocumentsDirectory();
    final extension = path.split('.').last;
    final file = File(
      '${directory.path}/avatar_${userId}_${DateTime.now().millisecondsSinceEpoch}.$extension',
    );
    await file.writeAsBytes(bytes);
    return file.path;
  }
}
