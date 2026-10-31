import 'package:equatable/equatable.dart';

class AuthTokens extends Equatable {
  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });

  factory AuthTokens.fromJson(Map<String, dynamic> json) {
    final expiresAt = json['expires_at'];
    final expiresIn = json['expires_in'];
    final expiry = expiresAt is num
        ? DateTime.fromMillisecondsSinceEpoch(
            expiresAt.toInt() * 1000,
            isUtc: true,
          )
        : DateTime.now().toUtc().add(
            Duration(seconds: expiresIn is num ? expiresIn.toInt() : 3600),
          );

    return AuthTokens(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      expiresAt: expiry,
    );
  }

  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;

  bool get isExpiringSoon {
    return DateTime.now().toUtc().isAfter(
      expiresAt.subtract(const Duration(seconds: 60)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'expires_at': expiresAt.millisecondsSinceEpoch ~/ 1000,
    };
  }

  @override
  List<Object?> get props => [accessToken, refreshToken, expiresAt];
}
