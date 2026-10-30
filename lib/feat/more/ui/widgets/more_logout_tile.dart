import 'package:flutter/material.dart';
import '../../../../core/helper/responsive_extension.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/app_pressable.dart';
import '../../data/more_content.dart';
import '../../data/more_icons.dart';

class MoreLogoutTile extends StatelessWidget {
  const MoreLogoutTile({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return AppPressable(
      onTap: onTap,
      pressedScale: 0.98,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: palette.error.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(color: palette.error.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 44.r,
              height: 44.r,
              decoration: BoxDecoration(
                color: palette.error.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(MoreIcons.logout, size: 22.r, color: palette.error),
            ),
            horizontalSpace(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    MoreContent.logoutTitle,
                    style: AppFonts.titleMedium.copyWith(
                      color: palette.error,
                      fontSize: 14.sp,
                    ),
                  ),
                  verticalSpace(height: 2),
                  Text(
                    MoreContent.logoutSubtitle,
                    style: AppFonts.bodySmall.copyWith(
                      color: palette.textSecondary,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ),
            Icon(MoreIcons.chevron, size: 18.r, color: palette.textSecondary),
          ],
        ),
      ),
    );
  }
}
