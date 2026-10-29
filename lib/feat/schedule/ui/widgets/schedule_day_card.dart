import 'package:flutter/material.dart';
import '../../../../core/helper/date_formatter.dart';
import '../../../../core/helper/responsive_extension.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import '../../data/models/schedule_lesson_model.dart';
import '../../data/schedule_content.dart';
import 'schedule_add_button.dart';
import 'schedule_card.dart';
import 'schedule_end_note.dart';
import 'schedule_lesson_card.dart';

class ScheduleDayCard extends StatelessWidget {
  const ScheduleDayCard({
    super.key,
    required this.date,
    required this.lessons,
    required this.onAdd,
    required this.onLessonTap,
    required this.onLessonMenu,
  });

  final DateTime date;
  final List<ScheduleLessonModel> lessons;
  final VoidCallback onAdd;
  final ValueChanged<String> onLessonTap;
  final ValueChanged<String> onLessonMenu;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isToday = DateFormatter.sameDay(date, DateTime.now());
    final endTitle = lessons.isEmpty
        ? ScheduleContent.noLessons
        : (isToday
              ? ScheduleContent.noMoreToday
              : ScheduleContent.noMoreOtherDay);

    return ScheduleCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    DateFormatter.full(date),
                    style: AppFonts.titleMedium.copyWith(
                      color: palette.textPrimary,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ),
              horizontalSpace(width: 10),
              ScheduleAddButton(label: ScheduleContent.addLesson, onTap: onAdd),
            ],
          ),
          verticalSpace(height: 14),
          for (final lesson in lessons) ...[
            ScheduleLessonCard(
              lesson: lesson,
              onTap: () => onLessonTap(lesson.id),
              onMenu: () => onLessonMenu(lesson.id),
            ),
            verticalSpace(height: 10),
          ],
          ScheduleEndNote(title: endTitle, onAdd: onAdd),
        ],
      ),
    );
  }
}
