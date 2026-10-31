import '../../const/user_role.dart';

class ProfileModel {
  const ProfileModel({
    required this.id,
    required this.role,
    required this.fullName,
    required this.username,
    required this.subject,
    required this.email,
    required this.phone,
    required this.parentPhone,
    required this.bio,
    required this.stage,
    required this.avatarPath,
    required this.verifiedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final roleName = json['role'];
    final verified = json['verified_at'];

    return ProfileModel(
      id: json['id'] as String,
      role: UserRole.values.firstWhere(
        (role) => role.name == roleName,
        orElse: () => UserRole.student,
      ),
      fullName: (json['full_name'] as String?) ?? '',
      username: json['username'] as String?,
      subject: (json['subject'] as String?) ?? '',
      email: (json['email'] as String?) ?? '',
      phone: (json['phone'] as String?) ?? '',
      parentPhone: (json['parent_phone'] as String?) ?? '',
      bio: (json['bio'] as String?) ?? '',
      stage: json['stage'] as String?,
      avatarPath: json['avatar_path'] as String?,
      verifiedAt: verified is String ? DateTime.tryParse(verified) : null,
    );
  }

  final String id;
  final UserRole role;
  final String fullName;
  final String? username;
  final String subject;
  final String email;
  final String phone;
  final String parentPhone;
  final String bio;
  final String? stage;
  final String? avatarPath;
  final DateTime? verifiedAt;
}
