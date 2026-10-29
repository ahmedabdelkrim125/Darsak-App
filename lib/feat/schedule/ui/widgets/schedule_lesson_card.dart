import 'package:flutter/material.dart';
import '../../../../core/helper/responsive_extension.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/app_pressable.dart';
import '../../../classroom/data/models/classroom_lesson.dart';
import '../../data/models/schedule_lesson_model.dart';
import '../../data/schedule_icons.dart';

class ScheduleLessonCard extends StatelessWidget {
  const ScheduleLessonCard({
    super.key,
    required this.lesson,
    required this.onTap,
    required this.onMenu,
  });

  final ScheduleLessonModel lesson;
  final VoidCallback onTap;
  final VoidCallback onMenu;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final tone = lesson.tone.resolve(palette);
    final isOnline = lesson.placeType == LessonPlaceType.online;
    final detailStyle = AppFonts.bodySmall.copyWith(
      color: palette.textSecondary,
      fontSize: 12.sp,
    );

    return AppPressable(
      onTap: onTap,
      pressedScale: 0.98,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          color: palette.background,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(width: 4.w, color: tone),
                horizontalSpace(width: 10),
                Center(
                  child: Container(
                    width: 48.r,
                    height: 48.r,
                    decoration: BoxDecoration(
                      color: tone.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Icon(lesson.icon, size: 26.r, color: tone),
                  ),
                ),
                horizontalSpace(width: 10),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 8.r,
                              height: 8.r,
                              decoration: BoxDecoration(
                                color: tone,
                                shape: BoxShape.circle,
                              ),
                            ),
                            horizontalSpace(width: 6),
                            Expanded(
                              child: Text(
                                lesson.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppFonts.titleMedium.copyWith(
                                  color: palette.textPrimary,
                                  fontSize: 15.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                        verticalSpace(height: 5),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: AlignmentDirectional.centerStart,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(lesson.grade, style: detailStyle),
                              horizontalSpace(width: 10),
                              Icon(
                                ScheduleIcons.students,
                                size: 14.r,
                                color: palette.textSecondary,
                              ),
                              horizontalSpace(width: 4),
                              Text(
                                '${lesson.studentsCount} طالب',
                                style: detailStyle,
                              ),
                            ],
                          ),
                        ),
                        verticalSpace(height: 4),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: AlignmentDirectional.centerStart,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isOnline
                                    ? ScheduleIcons.online
                                    : ScheduleIcons.onsite,
                                size: 14.r,
                                color: palette.textSecondary,
                              ),
                              horizontalSpace(width: 4),
                              Text(lesson.placeLabel, style: detailStyle),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                horizontalSpace(width: 8),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 2.w,
                        height: 34.h,
                        decoration: BoxDecoration(
                          color: tone,
                          borderRadius: BorderRadius.circular(1.r),
                        ),
                      ),
                      horizontalSpace(width: 6),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lesson.startTime,
                            style: AppFonts.bodySmall.copyWith(
                              color: palette.textPrimary,
                              fontSize: 12.sp,
                            ),
                          ),
                          verticalSpace(height: 6),
                          Text(
                            lesson.endTime,
                            style: AppFonts.bodySmall.copyWith(
                              color: palette.textPrimary,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                AppPressable(
                  onTap: onMenu,
                  pressedScale: 0.85,
                  child: SizedBox(
                    width: 34.w,
                    child: Center(
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: Icon(
                          ScheduleIcons.menu,
                          size: 20.r,
                          color: palette.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
