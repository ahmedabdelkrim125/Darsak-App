import '../../../../core/const/app_assets.dart';
import '../../../../core/const/user_role.dart';

class RegisterContent {
  const RegisterContent({
    required this.image,
    required this.title,
    required this.subtitles,
  });

  final String image;
  final String title;
  final List<String> subtitles;

  static RegisterContent of(UserRole role) {
    return switch (role) {
      UserRole.teacher => const RegisterContent(
        image: AppAssets.teacherAuth,
        title: 'إنشاء حساب معلم',
        subtitles: [
          'عرّف طلابك بنفسك',
          'تخصصك وبيانات التواصل معك',
          'أمّن حسابك بكلمة مرور قوية',
        ],
      ),
      UserRole.student => const RegisterContent(
        image: AppAssets.student,
        title: 'إنشاء حساب طالب',
        subtitles: [
          'عرّف معلميك بنفسك',
          'مرحلتك الدراسية وبيانات التواصل',
          'أمّن حسابك بكلمة مرور قوية',
        ],
      ),
    };
  }
}
