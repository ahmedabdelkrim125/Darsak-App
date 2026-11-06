import 'dart:async';
import 'dart:convert';
import '../database/database_provider.dart';
import '../database/sync_signal.dart';
import '../session/app_session.dart';
import 'avatar_storage.dart';

class ProfileSync {
  ProfileSync._();

  static final ProfileSync instance = ProfileSync._();

  bool _attached = false;
  int _version = -1;
  String _signature = '';
  String? _avatar;

  void attach() {
    if (_attached) return;
    _attached = true;
    AppSession.instance.addListener(_onChanged);
    _rebase();
  }

  void _rebase() {
    final session = AppSession.instance;
    _version = session.remoteVersion;
    _signature = _signatureOf(session);
    _avatar = session.avatarPath;
  }

  String _signatureOf(AppSession session) {
    return [
      session.fullName,
      session.subject,
      session.phone,
      session.bio,
      session.avatarPath ?? '',
    ].join('\u0001');
  }

  void _onChanged() {
    final session = AppSession.instance;
    if (session.remoteVersion != _version) {
      _rebase();
      return;
    }
    if (!session.isSignedIn || !DatabaseProvider.instance.isOpen) {
      _signature = _signatureOf(session);
      _avatar = session.avatarPath;
      return;
    }
    final next = _signatureOf(session);
    if (next == _signature) return;
    final avatarChanged = session.avatarPath != _avatar;
    _signature = next;
    _avatar = session.avatarPath;
    unawaited(_enqueue(session, avatarChanged));
  }

  Future<void> _enqueue(AppSession session, bool avatarChanged) async {
    final db = DatabaseProvider.instance.db;
    final userId = session.userId;

    var avatarLocal = session.avatarPath;
    if (avatarChanged && avatarLocal != null) {
      final stored = await AvatarStorage.persist(avatarLocal, userId);
      if (stored != avatarLocal) {
        session.replaceAvatarPath(stored);
        avatarLocal = stored;
      }
    }

    var changed = avatarChanged;
    final previous = await (db.select(
      db.outbox,
    )..where((t) => t.entity.equals('profiles') & t.entityId.equals(userId))).getSingleOrNull();
    if (previous?.payload != null) {
      try {
        final old = jsonDecode(previous!.payload!) as Map<String, dynamic>;
        if (old['avatar_changed'] == true) changed = true;
      } on FormatException {
        changed = changed;
      }
    }

    final payload = jsonEncode({
      'full_name': session.fullName,
      'subject': session.subject,
      'phone': session.phone,
      'bio': session.bio,
      'avatar_changed': changed,
      'avatar_local': avatarLocal,
    });
    await db.markDirty('profiles', userId, payload: payload);
    SyncSignal.onLocalWrite?.call();
  }
}
