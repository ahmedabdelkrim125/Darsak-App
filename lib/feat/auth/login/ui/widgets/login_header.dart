import 'package:flutter/material.dart';
import '../../../../../core/helper/spacing.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_palette.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key, required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'تسجيل الدخول',
          textAlign: TextAlign.center,
          style: AppFonts.headlineLarge.copyWith(color: palette.textPrimary),
        ),
        verticalSpace(height: 4),
        Text(
          'مرحباً بك من جديد',
          textAlign: TextAlign.center,
          style: AppFonts.bodyMedium.copyWith(color: palette.textSecondary),
        ),
        verticalSpace(height: 2),
        Text(
          description,
          textAlign: TextAlign.center,
          style: AppFonts.bodySmall.copyWith(
            color: palette.textPrimary.withValues(alpha: 0.75),
          ),
        ),
      ],
    );
  }
}
