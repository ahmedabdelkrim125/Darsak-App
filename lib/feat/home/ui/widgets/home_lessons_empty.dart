import 'package:flutter/material.dart';
import '../../../../core/helper/responsive_extension.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/app_pressable.dart';
import '../../data/home_content.dart';
import '../../data/home_icons.dart';

class HomeLessonsEmpty extends StatelessWidget {
  const HomeLessonsEmpty({super.key, required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 22.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: palette.background,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(HomeIcons.schedule, size: 34.r, color: palette.textSecondary),
          verticalSpace(height: 8),
          Text(
            HomeContent.lessonsEmpty,
            style: AppFonts.bodyMedium.copyWith(color: palette.textSecondary),
          ),
          verticalSpace(height: 10),
          AppPressable(
            onTap: onAdd,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: palette.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Text(
                HomeContent.lessonsEmptyAction,
                style: AppFonts.labelMedium.copyWith(
                  color: palette.primary,
                  fontSize: 13.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
