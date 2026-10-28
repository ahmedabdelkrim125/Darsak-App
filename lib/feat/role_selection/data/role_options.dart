import 'models/role_option_model.dart';
import '../../../core/const/app_assets.dart';
import '../../../core/const/user_role.dart';

class RoleOptions {
  RoleOptions._();

  static const List<RoleOptionModel> items = [
    RoleOptionModel(
      role: UserRole.teacher,
      title: 'معلم',
      description: 'أنشئ حصصك، أدر طلابك، وأرسل التذكيرات بسهولة.',
      image: AppAssets.teacher,
    ),
    RoleOptionModel(
      role: UserRole.student,
      title: 'طالب',
      description: 'تابع حصصك، واحصل على التذكيرات، ونظم دراستك بسهولة.',
      image: AppAssets.student,
    ),
  ];
}
