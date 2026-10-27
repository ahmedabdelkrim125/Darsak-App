import '../../../../core/const/user_role.dart';

class RegisterSuccessContent {
  const RegisterSuccessContent({
    required this.title,
    required this.welcome,
    required this.community,
    required this.action,
  });

  final String title;
  final String welcome;
  final String community;
  final String action;

  static RegisterSuccessContent of(UserRole role) {
    return switch (role) {
      UserRole.teacher => const RegisterSuccessContent(
        title: 'تم إنشاء الحساب بنجاح!',
        welcome: 'مرحباً بك في درسك',
        community: 'أصبحت الآن جزءاً من مجتمع المعلمين',
        action: 'ابدأ الآن',
      ),
      UserRole.student => const RegisterSuccessContent(
        title: 'تم إنشاء الحساب بنجاح!',
        welcome: 'مرحباً بك في درسك',
        community: 'أصبحت الآن جزءاً من مجتمع الطلاب',
        action: 'ابدأ الآن',
      ),
    };
  }
}