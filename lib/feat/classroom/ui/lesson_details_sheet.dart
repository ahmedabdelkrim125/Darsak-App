import 'package:flutter/material.dart';
import '../../../core/const/week_days.dart';
import '../../../core/helper/responsive_extension.dart';
import '../../../core/helper/spacing.dart';
import '../../../core/helper/time_formatter.dart';
import '../../../core/theme/app_fonts.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/widgets/app_bottom_sheet.dart';
import '../../../core/widgets/app_button.dart';
import '../data/classroom_store.dart';
import '../data/models/classroom_student.dart';
import 'add_student_sheet.dart';
import 'widgets/sheet_label.dart';

class LessonDetailsSheet extends StatelessWidget {
  const LessonDetailsSheet({
    super.key,
    required this.lessonId,
    required this.hostContext,
  });

  final String lessonId;
  final BuildContext hostContext;

  static Future<void> show(BuildContext context, String lessonId) {
    return AppBottomSheet.show<void>(
      context,
      title: 'تفاصيل الحصة',
      child: LessonDetailsSheet(lessonId: lessonId, hostContext: context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final store = ClassroomStore.instance;
    final lesson = store.lessonById(lessonId);
    final group = lesson == null ? null : store.groupById(lesson.groupId);
    if (lesson == null || group == null) return const SizedBox.shrink();

    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final current = store.groupById(group.id) ?? group;

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '${lesson.subject} - ${current.name}',
              style: AppFonts.titleMedium.copyWith(color: palette.textPrimary),
            ),
            verticalSpace(height: 6),
            Text(
              current.year.label,
              style: AppFonts.bodyMedium.copyWith(color: palette.textSecondary),
            ),
            verticalSpace(height: 4),
            Text(
              '${formatTime(lesson.time)} - ${formatTime(lesson.endTime)} · ${WeekDays.labels(lesson.weekdays)}',
              style: AppFonts.bodyMedium.copyWith(color: palette.textSecondary),
            ),
            verticalSpace(height: 4),
            Text(
              lesson.placeLabel,
              style: AppFonts.bodyMedium.copyWith(color: palette.textSecondary),
            ),
            verticalSpace(height: 18),
            SheetLabel('الطلاب (${current.students.length})'),
            if (current.students.isEmpty)
              Padding(
                padding: EdgeInsets.only(bottom: 14.h),
                child: Text(
                  'لا يوجد طلاب في هذه المجموعة بعد',
                  style: AppFonts.bodyMedium.copyWith(
                    color: palette.textPrimary,
                  ),
                ),
              )
            else
              for (final student in current.students)
                Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: _StudentRow(student: student),
                ),
            verticalSpace(height: 6),
            AppButton(
              label: 'إضافة طالب',
              expanded: true,
              onPressed: () {
                Navigator.of(context).pop();
                if (hostContext.mounted) {
                  AddStudentSheet.show(hostContext, initialGroupId: current.id);
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class _StudentRow extends StatelessWidget {
  const _StudentRow({required this.student});

  final ClassroomStudent student;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: palette.surface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.person_outline_rounded,
            size: 22.r,
            color: palette.primary,
          ),
          horizontalSpace(width: 10),
          Expanded(
            child: Text(
              student.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppFonts.bodyMedium.copyWith(color: palette.textPrimary),
            ),
          ),
          horizontalSpace(width: 8),
          if (student.hasAccount)
            Text(
              '@${student.username}',
              textDirection: TextDirection.ltr,
              style: AppFonts.bodySmall.copyWith(color: palette.primary),
            )
          else
            Text(
              'بدون حساب',
              style: AppFonts.bodySmall.copyWith(color: palette.textSecondary),
            ),
        ],
      ),
    );
  }
}
