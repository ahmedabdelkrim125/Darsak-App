import 'package:flutter/material.dart';
import '../../../../../core/helper/spacing.dart';
import '../../../../../core/theme/app_palette.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_button_style.dart';
import '../../../widgets/auth_divider.dart';
import '../../../../../core/helper/responsive_extension.dart';

class LoginActions extends StatelessWidget {
  const LoginActions({
    super.key,
    required this.onLogin,
    required this.onCreateAccount,
    this.isLoading = false,
  });

  final VoidCallback onLogin;
  final VoidCallback onCreateAccount;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppButton(
          label: 'تسجيل الدخول',
          expanded: true,
          radius: 16.r,
          height: 52.h,
          isLoading: isLoading,
          onPressed: onLogin,
        ),
        verticalSpace(height: 8),
        const AuthDivider(label: 'أو'),
        verticalSpace(height: 6),
        AppButton(
          label: 'إنشاء حساب جديد',
          variant: AppButtonVariant.outline,
          expanded: true,
          radius: 16.r,
          height: 46.h,
          borderColor: palette.primary.withValues(alpha: 0.35),
          onPressed: onCreateAccount,
        ),
      ],
    );
  }
}
