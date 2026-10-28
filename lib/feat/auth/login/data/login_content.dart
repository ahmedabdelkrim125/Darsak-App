import '../../../../core/const/app_assets.dart';
import '../../../../core/const/user_role.dart';

class LoginContent {
  const LoginContent({required this.image, required this.description});

  final String image;
  final String description;

  static LoginContent of(UserRole role) {
    return switch (role) {
      UserRole.teacher => const LoginContent(
        image: AppAssets.teacherAuth,
        description: 'سجل دخولك للمتابعة وإدارة حصصك بسهولة.',
      ),
      UserRole.student => const LoginContent(
        image: AppAssets.student,
        description: 'سجل دخولك لمتابعة حصصك وتذكيراتك بسهولة.',
      ),
    };
  }
}
