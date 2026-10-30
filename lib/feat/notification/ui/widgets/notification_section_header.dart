import 'package:flutter/material.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/helper/responsive_extension.dart';

class NotificationSectionHeader extends StatelessWidget {
  const NotificationSectionHeader({
    super.key,
    required this.heading,
    required this.date,
  });

  final String? heading;
  final String date;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: palette.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          if (heading != null)
            Text(
              heading!,
              style: AppFonts.titleLarge.copyWith(
                height: 1.2,
                color: palette.textPrimary,
              ),
            ),
          const Spacer(),
          Text(
            date,
            style: AppFonts.bodySmall.copyWith(
              height: 1.2,
              color: palette.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
