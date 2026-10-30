import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/helper/responsive_extension.dart';

class NotificationEmptyState extends StatelessWidget {
  const NotificationEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 92.r,
              height: 92.r,
              decoration: BoxDecoration(
                color: palette.track.withValues(alpha: 0.6),
                shape: BoxShape.circle,
              ),
              child: Icon(
                SolarIconsOutline.bell,
                size: 42.r,
                color: palette.primary,
              ),
            ),
            SizedBox(height: 18.h),
            Text(
              'لا توجد إشعارات',
              style: AppFonts.titleLarge.copyWith(color: palette.textPrimary),
            ),
            SizedBox(height: 6.h),
            Text(
              'ستظهر هنا كل التنبيهات الخاصة بك',
              textAlign: TextAlign.center,
              style: AppFonts.bodyMedium.copyWith(color: palette.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
