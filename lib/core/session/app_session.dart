import 'package:flutter/foundation.dart';
import '../const/user_role.dart';

class AppSession extends ChangeNotifier {
  AppSession._();

  static final AppSession instance = AppSession._();

  UserRole? _role;
  String _fullName = '';
  String _username = '';
  String _subject = '';

  UserRole? get role => _role;
  String get fullName => _fullName;
  String get username => _username;
  String get subject => _subject;
  bool get hasSubject => _subject.isNotEmpty;
  String get subjectKey => normalize(_subject);

  String get firstName {
    if (_fullName.isEmpty) return '';
    return _fullName.split(RegExp(r'\s+')).first;
  }

  void signIn({
    required UserRole role,
    String? fullName,
    String? username,
    String? subject,
  }) {
    _role = role;
    if (fullName != null) _fullName = _clean(fullName);
    if (username != null) _username = username.trim();
    if (subject != null) _subject = _clean(subject);
    notifyListeners();
  }

  void updateSubject(String value) {
    _subject = _clean(value);
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
