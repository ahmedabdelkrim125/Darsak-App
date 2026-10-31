import '../auth/auth_tokens.dart';
import 'auth_user_model.dart';

class AuthResponse {
  const AuthResponse({required this.user, this.tokens});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final hasSession =
        json['access_token'] is String && json['refresh_token'] is String;
    final userJson = json['user'] is Map
        ? Map<String, dynamic>.from(json['user'] as Map)
        : json;

    return AuthResponse(
      user: AuthUserModel.fromJson(userJson),
      tokens: hasSession ? AuthTokens.fromJson(json) : null,
    );
  }

  final AuthUserModel user;
  final AuthTokens? tokens;

  bool get hasSession => tokens != null;
}
