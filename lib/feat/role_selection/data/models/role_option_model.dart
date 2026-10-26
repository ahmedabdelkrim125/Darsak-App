import '../../../../core/const/user_role.dart';

class RoleOptionModel {
  const RoleOptionModel({
    required this.role,
    required this.title,
    required this.description,
    required this.image,
  });

  final UserRole role;
  final String title;
  final String description;
  final String image;
}
