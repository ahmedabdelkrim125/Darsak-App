import '../../../../core/const/app_assets.dart';
import '../../../../core/const/user_role.dart';

class ForgotPasswordContent {
  const ForgotPasswordContent({required this.image});

  final String image;

  static const List<String> titles = [
    'نسيت كلمة المرور؟',
    'رمز التحقق',
    'كلمة مرور جديدة',
  ];

  static ForgotPasswordContent of(UserRole role) {
    return switch (role) {
      UserRole.teacher => const ForgotPasswordContent(
        image: AppAssets.teacherAuth,
      ),
      UserRole.student => const ForgotPasswordContent(image: AppAssets.student),
    };
  }

  String subtitle(int step, String email) {
    return switch (step) {
      0 => 'أدخل بريدك الإلكتروني وسنرسل لك رمز التحقق',
      1 => 'أدخل الرمز المرسل إلى ${_mask(email)}',
      _ => 'اختر كلمة مرور قوية لحسابك',
    };
  }

  static String _mask(String email) {
    final value = email.trim();
    final at = value.indexOf('@');
    if (at <= 0) return value;
    final name = value.substring(0, at);
    final visible = name.length <= 2
        ? name.substring(0, 1)
        : name.substring(0, 2);
    return '$visible***${value.substring(at)}';
  }
}
