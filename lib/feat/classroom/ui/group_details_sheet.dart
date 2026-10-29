import 'package:flutter/material.dart';
import '../../../core/helper/responsive_extension.dart';
import '../../../core/helper/spacing.dart';
import '../../../core/theme/app_fonts.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/widgets/app_bottom_sheet.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_toast.dart';
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

    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final group = store.groupById(groupId);
        if (group == null) return const SizedBox.shrink();

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
            else
              for (final student in group.students)
                Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: ClassroomStudentRow(
                    key: ValueKey(student.id),
                    student: student,
                    onRemove: () {
                      store.removeStudent(
                        groupId: group.id,
                        studentId: student.id,
                      );
                      AppToast.show(context, 'تم حذف الطالب');
                    },
                  ),
                ),
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
