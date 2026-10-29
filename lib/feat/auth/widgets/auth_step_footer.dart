import 'package:flutter/material.dart';
import '../../../core/helper/spacing.dart';
import '../../../core/theme/app_fonts.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_button.dart';
import '../../../core/helper/responsive_extension.dart';

class AuthStepFooter extends StatelessWidget {
  const AuthStepFooter({
    super.key,
    required this.label,
    required this.onPressed,
    required this.prompt,
    required this.linkLabel,
    required this.onLink,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback onPressed;
  final String prompt;
  final String linkLabel;
  final VoidCallback onLink;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppButton(
          label: label,
          expanded: true,
          radius: 16.r,
          height: 52.h,
          isLoading: isLoading,
          onPressed: onPressed,
        ),
        verticalSpace(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              prompt,
              style: AppFonts.bodySmall.copyWith(color: palette.textSecondary),
            ),
            AppTextButton(
              label: linkLabel,
              onPressed: onLink,
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
