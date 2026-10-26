import 'package:flutter/material.dart';
import 'package:darsak_app/core/helper/spacing.dart';
import 'package:darsak_app/core/theme/app_fonts.dart';
import 'package:darsak_app/core/theme/app_palette.dart';
import '../../../../core/const/app_assets.dart';
import '../../../../core/helper/responsive_extension.dart';

class RoleHeader extends StatelessWidget {
  const RoleHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Column(
      children: [
        Image.asset(AppAssets.logo, width: 170.w, fit: BoxFit.contain),
        verticalSpace(height: 20),
        Text(
          'من أنت؟',
          textAlign: TextAlign.center,
          style: AppFonts.displayLarge.copyWith(color: palette.textPrimary),
        ),
        verticalSpace(height: 8),
        Text(
          'اختر نوع حسابك للبدء',
          textAlign: TextAlign.center,
          style: AppFonts.bodyLarge.copyWith(color: palette.textSecondary),
        ),
      ],
    );
  }
}
