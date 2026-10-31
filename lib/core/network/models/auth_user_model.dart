import 'package:equatable/equatable.dart';

class AuthUserModel extends Equatable {
  const AuthUserModel({
    required this.id,
    required this.email,
    this.phone,
    this.emailConfirmedAt,
    this.alreadyRegistered = false,
    this.metadata = const {},
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    final metadata = json['user_metadata'];
    final confirmed = json['email_confirmed_at'] ?? json['confirmed_at'];
    final identities = json['identities'];

    return AuthUserModel(
      id: json['id'] as String,
      email: (json['email'] as String?) ?? '',
      phone: json['phone'] as String?,
      emailConfirmedAt: confirmed is String
          ? DateTime.tryParse(confirmed)
          : null,
      alreadyRegistered: identities is List && identities.isEmpty,
      metadata: metadata is Map
          ? Map<String, dynamic>.from(metadata)
          : const {},
    );
  }

  final String id;
  final String email;
  final String? phone;
  final DateTime? emailConfirmedAt;
  final bool alreadyRegistered;
  final Map<String, dynamic> metadata;

  bool get isEmailConfirmed => emailConfirmedAt != null;

  @override
  List<Object?> get props => [
    id,
    email,
    phone,
    emailConfirmedAt,
    alreadyRegistered,
    metadata,
  ];
}
