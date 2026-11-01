import 'package:flutter/material.dart';
import '../../../core/const/week_days.dart';
import '../../../core/helper/responsive_extension.dart';
import '../../../core/helper/spacing.dart';
import '../../../core/theme/app_fonts.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/widgets/app_page_scaffold.dart';
import '../../classroom/data/classroom_store.dart';
import '../../classroom/ui/lesson_actions_sheet.dart';
import '../../home/ui/home_actions.dart';
import '../../schedule/data/schedule_content.dart';
import '../../schedule/data/schedule_lesson_mapper.dart';
import '../../schedule/ui/widgets/schedule_card.dart';
import '../../schedule/ui/widgets/schedule_lesson_card.dart';


class FullScheduleScreen extends StatelessWidget {
  const FullScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final store = ClassroomStore.instance;

    return AppPageScaffold(
      title: 'الجدول الكامل',
      child: ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          final today = DateTime.now().weekday;
          final days = [
            for (final day in WeekDays.order)
              if (ScheduleLessonMapper.forWeekday(store, day).isNotEmpty) day,
          ];

          if (days.isEmpty) {
            return Padding(
              padding: EdgeInsets.only(top: 80.h),
              child: Center(
                child: Text(
                  ScheduleContent.emptyDescription,
                  textAlign: TextAlign.center,
                  style: AppFonts.bodyMedium.copyWith(
                    color: palette.textSecondary,
                  ),
                ),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final day in days) ...[
                ScheduleCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Text(
                            WeekDays.label(day),
                            style: AppFonts.titleMedium.copyWith(
                              color: palette.textPrimary,
                              fontSize: 16.sp,
                            ),
                          ),
                          if (day == today) ...[
                            horizontalSpace(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 3.h,
                              ),
                              decoration: BoxDecoration(
                                color: palette.primary.withValues(alpha: 0.14),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Text(
                                'اليوم',
                                style: AppFonts.bodySmall.copyWith(
                                  color: palette.primary,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      verticalSpace(height: 12),
                      for (final lesson
                          in ScheduleLessonMapper.forWeekday(store, day)) ...[
                        ScheduleLessonCard(
                          lesson: lesson,
                          onTap: () =>
                              HomeActions.openLesson(context, lesson.id),
                          onMenu: () =>
                              LessonActionsSheet.show(context, lesson.id),
                        ),
                        verticalSpace(height: 10),
                      ],
                    ],
                  ),
                ),
                verticalSpace(height: 14),
              ],
            ],
          );
        },
      ),
    );
  }
}