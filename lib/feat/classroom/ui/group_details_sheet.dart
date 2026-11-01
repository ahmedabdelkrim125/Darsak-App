import 'package:flutter/material.dart';
import '../../../core/helper/responsive_extension.dart';
import '../../../core/helper/spacing.dart';
import '../../../core/theme/app_fonts.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/widgets/app_bottom_sheet.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_toast.dart';
import '../../attendance/data/attendance_store.dart';
import '../../attendance/ui/student_attendance_sheet.dart';
import '../data/classroom_store.dart';
import 'add_student_sheet.dart';
import 'widgets/classroom_student_row.dart';
import 'widgets/sheet_label.dart';

class GroupDetailsSheet extends StatelessWidget {
  const GroupDetailsSheet({super.key, required this.groupId});

  final String groupId;

  static Future<void> show(BuildContext context, String groupId) {
    return AppBottomSheet.show<void>(
      context,
      title: 'تفاصيل المجموعة',
      child: GroupDetailsSheet(groupId: groupId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final store = ClassroomStore.instance;
    final attendance = AttendanceStore.instance;

    return ListenableBuilder(
      listenable: Listenable.merge([store, attendance]),
      builder: (context, _) {
        final group = store.groupById(groupId);
        if (group == null) return const SizedBox.shrink();
        final today = DateTime.now();

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '${group.subject} - ${group.name}',
              style: AppFonts.titleMedium.copyWith(color: palette.textPrimary),
            ),
            verticalSpace(height: 6),
            Text(
              group.year.label,
              style: AppFonts.bodyMedium.copyWith(color: palette.textSecondary),
            ),
            verticalSpace(height: 4),
            Text(
              '${group.students.length} طالب · ${store.weeklyLessonsOf(group.id)} حصة أسبوعياً',
              style: AppFonts.bodyMedium.copyWith(color: palette.textSecondary),
            ),
            verticalSpace(height: 18),
            SheetLabel('الطلاب (${group.students.length})'),
            if (group.students.isEmpty)
              Padding(
                padding: EdgeInsets.only(bottom: 14.h),
                child: Text(
                  'لا يوجد طلاب في هذه المجموعة بعد',
                  style: AppFonts.bodyMedium.copyWith(
                    color: palette.textPrimary,
                  ),
                ),
              )
            else ...[
              Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: Text(
                  'اضغط على الطالب لتسجيل الحضور والغياب',
                  style: AppFonts.bodySmall.copyWith(
                    color: palette.textSecondary,
                  ),
                ),
              ),
              for (final student in group.students)
                Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: ClassroomStudentRow(
                    key: ValueKey(student.id),
                    student: student,
                    todayStatus: attendance.statusOf(student.id, today),
                    onTap: () => StudentAttendanceSheet.show(
                      context,
                      groupId: group.id,
                      studentId: student.id,
                    ),
                    onRemove: () {
                      store.removeStudent(
                        groupId: group.id,
                        studentId: student.id,
                      );
                      AppToast.show(context, 'تم حذف الطالب');
                    },
                  ),
                ),
            ],
            verticalSpace(height: 6),
            AppButton(
              label: 'إضافة طالب',
              expanded: true,
              onPressed: () =>
                  AddStudentSheet.show(context, initialGroupId: group.id),
            ),
          ],
        );
      },
    );
  }
}