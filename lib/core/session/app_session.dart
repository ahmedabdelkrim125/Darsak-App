import 'package:flutter/foundation.dart';
import '../const/user_role.dart';
import '../network/models/profile_model.dart';

class AppSession extends ChangeNotifier {
  AppSession._();

  static final AppSession instance = AppSession._();

  String _userId = '';
  UserRole? _role;
  String _fullName = '';
  String _username = '';
  String _subject = '';
  String _email = '';
  String _phone = '';
  String _bio = '';
  String? _avatarPath;
  String? _avatarRemote;
  DateTime? _verifiedAt;
  int _remoteVersion = 0;

  String get userId => _userId;
  bool get isSignedIn => _userId.isNotEmpty && _role != null;
  UserRole? get role => _role;
  String get fullName => _fullName;
  String get username => _username;
  String get subject => _subject;
  String get email => _email;
  String get phone => _phone;
  String get bio => _bio;
  String? get avatarPath => _avatarPath;
  String? get avatarRemote => _avatarRemote;
  int get remoteVersion => _remoteVersion;
  bool get hasSubject => _subject.isNotEmpty;
  String get subjectKey => normalize(_subject);
  bool get isVerified => _verifiedAt != null;
  DateTime? get verifiedAt => _verifiedAt;

  String get firstName {
    if (_fullName.isEmpty) return '';
    return _fullName.split(RegExp(r'\s+')).first;
  }

  void applyProfile(ProfileModel profile) {
    final fullName = _clean(profile.fullName);
    final username = profile.username ?? '';
    final subject = _clean(profile.subject);
    final same =
        _userId == profile.id &&
        _role == profile.role &&
        _fullName == fullName &&
        _username == username &&
        _subject == subject &&
        _email == profile.email &&
        _phone == profile.phone &&
        _bio == profile.bio &&
        _verifiedAt == profile.verifiedAt;
    if (same) return;

    _userId = profile.id;
    _role = profile.role;
    _fullName = fullName;
    _username = username;
    _subject = subject;
    _email = profile.email;
    _phone = profile.phone;
    _bio = profile.bio;
    _verifiedAt = profile.verifiedAt;
    _remoteVersion++;
    notifyListeners();
  }

  Map<String, dynamic> toCache() {
    return {
      'user_id': _userId,
      'role': _role?.name,
      'full_name': _fullName,
      'username': _username,
      'subject': _subject,
      'email': _email,
      'phone': _phone,
      'bio': _bio,
      'avatar_path': _avatarPath,
      'avatar_remote': _avatarRemote,
      'verified_at': _verifiedAt?.toIso8601String(),
    };
  }

  void restore(Map<String, dynamic> json) {
    final roleName = json['role'];
    final verified = json['verified_at'];
    _userId = (json['user_id'] as String?) ?? '';
    _role = UserRole.values
        .where((role) => role.name == roleName)
        .firstOrNull;
    _fullName = (json['full_name'] as String?) ?? '';
    _username = (json['username'] as String?) ?? '';
    _subject = (json['subject'] as String?) ?? '';
    _email = (json['email'] as String?) ?? '';
    _phone = (json['phone'] as String?) ?? '';
    _bio = (json['bio'] as String?) ?? '';
    _avatarPath = json['avatar_path'] as String?;
    _avatarRemote = json['avatar_remote'] as String?;
    _verifiedAt = verified is String ? DateTime.tryParse(verified) : null;
    _remoteVersion++;
    notifyListeners();
  }

  void signIn({
    required UserRole role,
    String? fullName,
    String? username,
    String? subject,
    String? email,
    String? phone,
  }) {
    _role = role;
    if (fullName != null) _fullName = _clean(fullName);
    if (username != null) _username = username.trim();
    if (subject != null) _subject = _clean(subject);
    if (email != null && email.trim().isNotEmpty) _email = email.trim();
    if (phone != null && phone.trim().isNotEmpty) _phone = phone.trim();
    notifyListeners();
  }

  void updateProfile({
    required String fullName,
    required String email,
    required String phone,
    required String bio,
    String? subject,
  }) {
    _fullName = _clean(fullName);
    _email = email.trim();
    _phone = phone.trim();
    _bio = bio.trim();
    if (subject != null) _subject = _clean(subject);
    notifyListeners();
  }

  void updateSubject(String value) {
    _subject = _clean(value);
    notifyListeners();
  }

  void setAvatar(String? path) {
    _avatarPath = path;
    notifyListeners();
  }

  void replaceAvatarPath(String path) {
    _avatarPath = path;
    _remoteVersion++;
    notifyListeners();
  }

  void setAvatarRemote(String? remote) {
    _avatarRemote = remote;
    _remoteVersion++;
    notifyListeners();
  }

  void setAvatarFromRemote(String? localPath, String? remote) {
    _avatarPath = localPath;
    _avatarRemote = remote;
    _remoteVersion++;
    notifyListeners();
  }

  void markVerified() {
    _verifiedAt = DateTime.now();
    notifyListeners();
  }

  void signOut() {
    _userId = '';
    _role = null;
    _fullName = '';
    _username = '';
    _subject = '';
    _email = '';
    _phone = '';
    _bio = '';
    _avatarPath = null;
    _avatarRemote = null;
    _verifiedAt = null;
    _remoteVersion++;
    notifyListeners();
  }

  static String _clean(String value) {
    return value.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  static String normalize(String value) {
    final cleaned = _clean(value);
    if (cleaned.startsWith('ال') && cleaned.length > 2) {
      return cleaned.substring(2);
    }
    return cleaned;
  }
}
