import 'package:flutter/material.dart';
import '../../../../core/helper/responsive_extension.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/app_pressable.dart';
import '../../data/home_icons.dart';

class HomeSectionCard extends StatelessWidget {
  const HomeSectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.actionLabel,
    required this.onAction,
    required this.child,
  });

  final String title;
  final IconData icon;
  final String actionLabel;
  final VoidCallback onAction;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 16.h, 12.w, 14.h),
      decoration: BoxDecoration(
        color: palette.surface.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(26.r),
        border: Border.all(color: palette.primary.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                Icon(icon, size: 24.r, color: palette.textPrimary),
                horizontalSpace(width: 8),
                Text(
                  title,
                  style: AppFonts.titleMedium.copyWith(
                    color: palette.textPrimary,
                  ),
                ),
                const Spacer(),
                AppPressable(
                  onTap: onAction,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        actionLabel,
                        style: AppFonts.labelMedium.copyWith(
                          color: palette.primary,
                          fontSize: 13.sp,
                        ),
                      ),
                      horizontalSpace(width: 2),
                      Icon(
                        HomeIcons.chevron,
                        size: 16.r,
                        color: palette.primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          verticalSpace(height: 14),
          child,
        ],
      ),
    );
  }
}
