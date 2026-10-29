import 'package:flutter/material.dart';
import '../../../../core/helper/responsive_extension.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/app_pressable.dart';
import '../../data/home_icons.dart';
import '../../data/models/home_lesson_model.dart';

class HomeLessonTile extends StatelessWidget {
  const HomeLessonTile({super.key, required this.lesson, required this.onTap});

  final HomeLessonModel lesson;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final tone = lesson.tone.resolve(palette);

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
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 14.h,
                    ),
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
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                        verticalSpace(height: 6),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: AlignmentDirectional.centerStart,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                lesson.grade,
                                style: AppFonts.bodySmall.copyWith(
                                  color: palette.textSecondary,
                                  fontSize: 12.sp,
                                ),
                              ),
                              horizontalSpace(width: 12),
                              Icon(
                                HomeIcons.students,
                                size: 14.r,
                                color: palette.textSecondary,
                              ),
                              horizontalSpace(width: 4),
                              Text(
                                '${lesson.studentsCount} طالب',
                                style: AppFonts.bodySmall.copyWith(
                                  color: palette.textSecondary,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: palette.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          HomeIcons.clock,
                          size: 18.r,
                          color: palette.primary,
                        ),
                        horizontalSpace(width: 6),
                        Text(
                          lesson.time,
                          style: AppFonts.bodyMedium.copyWith(
                            color: palette.textPrimary,
                            fontSize: 13.sp,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                horizontalSpace(width: 8),
                Center(
                  child: Container(
                    width: 36.r,
                    height: 36.r,
                    decoration: BoxDecoration(
                      color: palette.primary.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Icon(
                      HomeIcons.chevron,
                      size: 18.r,
                      color: palette.textSecondary,
                    ),
                  ),
                ),
                horizontalSpace(width: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
