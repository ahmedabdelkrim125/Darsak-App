import 'package:flutter/material.dart';
import '../../../core/helper/date_formatter.dart';
import '../../../core/helper/responsive_extension.dart';
import '../../../core/helper/spacing.dart';
import '../../../core/theme/app_fonts.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/widgets/app_bottom_sheet.dart';
import '../../classroom/data/classroom_store.dart';
import '../../classroom/data/models/classroom_student.dart';
import '../../classroom/ui/widgets/sheet_label.dart';
import '../../schedule/ui/widgets/schedule_month_nav.dart';
import '../data/attendance_store.dart';
import '../data/models/attendance_status.dart';
import 'widgets/attendance_record_row.dart';
import 'widgets/attendance_status_button.dart';
import 'widgets/attendance_summary_row.dart';

class StudentAttendanceSheet extends StatefulWidget {
  const StudentAttendanceSheet({
    super.key,
    required this.groupId,
    required this.studentId,
  });

  final String groupId;
  final String studentId;

  static Future<void> show(
    BuildContext context, {
    required String groupId,
    required String studentId,
  }) {
    return AppBottomSheet.show<void>(
      context,
      title: 'حضور الطالب',
      child: StudentAttendanceSheet(groupId: groupId, studentId: studentId),
    );
  }

  @override
  State<StudentAttendanceSheet> createState() => _StudentAttendanceSheetState();
}

class _StudentAttendanceSheetState extends State<StudentAttendanceSheet> {
  late DateTime _selected = DateFormatter.dateOnly(DateTime.now());
  late DateTime _month = DateFormatter.monthStart(_selected);

  DateTime get _today => DateFormatter.dateOnly(DateTime.now());

  void _setDate(DateTime date) {
    final day = DateFormatter.dateOnly(date);
    if (day.isAfter(_today)) return;
    setState(() {
      _selected = day;
      _month = DateFormatter.monthStart(day);
    });
  }

  void _shiftDay(int step) {
    _setDate(DateTime(_selected.year, _selected.month, _selected.day + step));
  }

  void _shiftMonth(int step) {
    final month = DateFormatter.addMonths(_month, step);
    if (month.isAfter(DateFormatter.monthStart(_today))) return;
    setState(() => _month = month);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selected,
      firstDate: DateTime(2020),
      lastDate: _today,
    );
    if (picked == null || !mounted) return;
    _setDate(picked);
  }

  void _mark(AttendanceStatus status) {
    AttendanceStore.instance.mark(
      studentId: widget.studentId,
      groupId: widget.groupId,
      date: _selected,
      status: status,
    );
  }

  ClassroomStudent? _find(List<ClassroomStudent> students) {
    for (final student in students) {
      if (student.id == widget.studentId) return student;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final classroom = ClassroomStore.instance;
    final attendance = AttendanceStore.instance;

    return ListenableBuilder(
      listenable: Listenable.merge([classroom, attendance]),
      builder: (context, _) {
        final group = classroom.groupById(widget.groupId);
        final student = group == null ? null : _find(group.students);
        if (group == null || student == null) return const SizedBox.shrink();

        final current = attendance.statusOf(student.id, _selected);
        final records = attendance.recordsOf(student.id, _month);
        final summary = attendance.summaryOf(student.id, _month);
        final isToday = DateFormatter.sameDay(_selected, _today);
        final dateLabel = isToday
            ? 'اليوم - ${DateFormatter.shortDate(_selected)}'
            : DateFormatter.full(_selected);

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              student.name,
              style: AppFonts.titleMedium.copyWith(color: palette.textPrimary),
            ),
            verticalSpace(height: 4),
            Text(
              '${group.subject} - ${group.name} · ${group.year.label}',
              style: AppFonts.bodyMedium.copyWith(color: palette.textSecondary),
            ),
            verticalSpace(height: 18),
            const SheetLabel('تسجيل الحضور'),
            ScheduleMonthNav(
              label: dateLabel,
              onPrevious: () => _shiftDay(-1),
              onNext: () => _shiftDay(1),
              onPickDate: _pickDate,
            ),
            verticalSpace(height: 12),
            Row(
              children: [
                Expanded(
                  child: AttendanceStatusButton(
                    status: AttendanceStatus.present,
                    selected: current == AttendanceStatus.present,
                    onTap: () => _mark(AttendanceStatus.present),
                  ),
                ),
                horizontalSpace(width: 8),
                Expanded(
                  child: AttendanceStatusButton(
                    status: AttendanceStatus.tardy,
                    selected: current == AttendanceStatus.tardy,
                    onTap: () => _mark(AttendanceStatus.tardy),
                  ),
                ),
                horizontalSpace(width: 8),
                Expanded(
                  child: AttendanceStatusButton(
                    status: AttendanceStatus.absent,
                    selected: current == AttendanceStatus.absent,
                    onTap: () => _mark(AttendanceStatus.absent),
                  ),
                ),
              ],
            ),
            verticalSpace(height: 8),
            Text(
              'اضغط على الحالة المحددة مرة أخرى لإلغاء التسجيل',
              textAlign: TextAlign.center,
              style: AppFonts.bodySmall.copyWith(color: palette.textSecondary),
            ),
            verticalSpace(height: 18),
            const SheetLabel('ملخص الشهر'),
            ScheduleMonthNav(
              label: DateFormatter.monthYear(_month),
              onPrevious: () => _shiftMonth(-1),
              onNext: () => _shiftMonth(1),
              onPickDate: _pickDate,
            ),
            verticalSpace(height: 12),
            AttendanceSummaryRow(summary: summary),
            verticalSpace(height: 16),
            SheetLabel('السجل (${records.length})'),
            if (records.isEmpty)
              Text(
                'لا يوجد تسجيل في هذا الشهر',
                style: AppFonts.bodyMedium.copyWith(
                  color: palette.textPrimary,
                ),
              )
            else
              for (final record in records)
                Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: AttendanceRecordRow(
                    key: ValueKey(record.id),
                    record: record,
                    selected: DateFormatter.sameDay(record.date, _selected),
                    onTap: () => _setDate(record.date),
                  ),
                ),
          ],
        );
      },
    );
  }
}
