import 'package:flutter/material.dart';
import 'package:darsak_app/core/helper/spacing.dart';
import 'package:darsak_app/core/theme/app_fonts.dart';
import 'package:darsak_app/core/theme/app_palette.dart';

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppFonts.headlineLarge.copyWith(color: palette.textPrimary),
        ),
        verticalSpace(height: 4),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: Text(
            subtitle,
            key: ValueKey(subtitle),
            textAlign: TextAlign.center,
            style: AppFonts.bodyMedium.copyWith(color: palette.textSecondary),
          ),
        ),
      ],
    );
  }
}
