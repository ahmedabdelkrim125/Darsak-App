import 'package:flutter/material.dart';
import '../../../../core/const/app_assets.dart';
import '../../../../core/helper/responsive_extension.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import '../../data/schedule_content.dart';
import 'schedule_add_button.dart';

class ScheduleEndNote extends StatelessWidget {
  const ScheduleEndNote({super.key, required this.title, required this.onAdd});

  final String title;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 8.w, 14.h),
      decoration: BoxDecoration(
        color: palette.background,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppFonts.titleMedium.copyWith(
                    color: palette.textPrimary,
                    fontSize: 14.sp,
                  ),
                ),
                verticalSpace(height: 4),
                Text(
                  ScheduleContent.emptyDescription,
                  style: AppFonts.bodySmall.copyWith(
                    color: palette.textSecondary,
                    fontSize: 12.sp,
                  ),
                ),
                verticalSpace(height: 12),
                ScheduleAddButton(
                  label: ScheduleContent.addLesson,
                  onTap: onAdd,
                ),
              ],
            ),
          ),
          horizontalSpace(width: 8),
          Image.asset(
            AppAssets.scheduleEmpty,
            width: 96.w,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
