import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/const/user_role.dart';

class PendingSignup {
  const PendingSignup({required this.role, required this.email});

  final UserRole role;
  final String email;
}

class PendingSignupStore {
  static const String _key = 'pending_signup';
  static const Duration _lifetime = Duration(minutes: 55);

  Future<void> save({required UserRole role, required String email}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode({
        'role': role.name,
        'email': email,
        'at': DateTime.now().toIso8601String(),
      }),
    );
  }

  Future<PendingSignup?> read() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return null;
    try {
      final json = jsonDecode(raw);
      if (json is! Map) return null;
      final at = DateTime.tryParse('${json['at']}');
      final email = '${json['email'] ?? ''}';
      final role = UserRole.values
          .where((value) => value.name == json['role'])
          .firstOrNull;
      final expired =
          at == null || DateTime.now().difference(at) > _lifetime;
      if (expired || email.isEmpty || role == null) {
        await prefs.remove(_key);
        return null;
      }
      return PendingSignup(role: role, email: email);
    } on FormatException {
      await prefs.remove(_key);
      return null;
    }
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}