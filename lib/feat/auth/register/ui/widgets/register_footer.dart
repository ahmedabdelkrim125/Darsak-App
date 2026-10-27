import 'package:flutter/material.dart';
import 'package:darsak_app/core/helper/spacing.dart';
import 'package:darsak_app/core/theme/app_fonts.dart';
import 'package:darsak_app/core/theme/app_palette.dart';
import 'package:darsak_app/core/widgets/app_button.dart';
import 'package:darsak_app/core/widgets/app_text_button.dart';
import '../../../../../core/helper/responsive_extension.dart';

class RegisterFooter extends StatelessWidget {
  const RegisterFooter({
    super.key,
    required this.isLast,
    required this.onNext,
    required this.onLogin,
  });

  final bool isLast;
  final VoidCallback onNext;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppButton(
          label: isLast ? 'إنشاء الحساب' : 'التالي',
          expanded: true,
          radius: 16.r,
          height: 52.h,
          onPressed: onNext,
        ),
        verticalSpace(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'لديك حساب بالفعل؟',
              style: AppFonts.bodySmall.copyWith(color: palette.textSecondary),
            ),
            AppTextButton(
              label: 'تسجيل الدخول',
              onPressed: onLogin,
              color: palette.primary,
              style: AppFonts.labelMedium,
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
            ),
          ],
        ),
      ],
    );
  }
}
