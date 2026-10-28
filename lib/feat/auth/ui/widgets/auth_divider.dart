import 'package:flutter/material.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/helper/responsive_extension.dart';

class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final line = Container(height: 1.5, color: palette.track);

    return SizedBox(
      height: 20.h,
      child: Row(
        children: [
          Expanded(child: line),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              label,
              style: AppFonts.bodySmall.copyWith(color: palette.textSecondary),
            ),
          ),
          Expanded(child: line),
        ],
      ),
    );
  }
}
