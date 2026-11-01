import 'package:flutter/material.dart';
import '../../../core/helper/date_formatter.dart';
import '../../../core/helper/responsive_extension.dart';
import '../../../core/helper/spacing.dart';
import '../../../core/theme/app_fonts.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/widgets/app_page_scaffold.dart';
import '../../attendance/data/attendance_store.dart';
import '../../attendance/ui/student_attendance_sheet.dart';
import '../../classroom/data/classroom_store.dart';
import '../../schedule/ui/widgets/schedule_card.dart';
import '../../schedule/ui/widgets/schedule_month_nav.dart';
import '../data/models/payment_filter.dart';
import '../data/models/payment_status.dart';
import '../data/models/payments_summary.dart';
import '../data/payments_content.dart';
import '../data/payments_store.dart';
import 'student_payment_sheet.dart';
import 'widgets/group_student_tile.dart';
import 'widgets/payments_summary_row.dart';

class GroupPaymentsScreen extends StatefulWidget {
  const GroupPaymentsScreen({
    super.key,
    required this.groupId,
    required this.month,
  });

  final String groupId;
  final DateTime month;

  static Future<void> open(
    BuildContext context, {
    required String groupId,
    required DateTime month,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => GroupPaymentsScreen(groupId: groupId, month: month),
      ),
    );
  }

  @override
  State<GroupPaymentsScreen> createState() => _GroupPaymentsScreenState();
}

class _GroupPaymentsScreenState extends State<GroupPaymentsScreen> {
  late DateTime _month = DateFormatter.monthStart(widget.month);
  PaymentStatus? _status;

  void _shift(int step) {
    setState(() => _month = DateFormatter.addMonths(_month, step));
  }

  Future<void> _pickMonth() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _month,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked == null || !mounted) return;
    setState(() => _month = DateFormatter.monthStart(picked));
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final classroom = ClassroomStore.instance;
    final payments = PaymentsStore.instance;
    final attendance = AttendanceStore.instance;

    return ListenableBuilder(
      listenable: Listenable.merge([classroom, payments, attendance]),
      builder: (context, _) {
        final group = classroom.groupById(widget.groupId);
        if (group == null) {
          return const AppPageScaffold(
            title: 'المجموعة',
            child: SizedBox.shrink(),
          );
        }
        final all = payments.entries(
          _month,
          filter: PaymentFilter(groupId: group.id),
        );
        final summary = PaymentsSummary.of(all);
        final entries = payments.entries(
          _month,
          filter: PaymentFilter(groupId: group.id, status: _status),
        );
        final today = DateTime.now();
        var collected = 0;
        for (final entry in all) {
          collected += entry.paid;
        }
        final expected = group.monthlyFee * group.students.length;

        return AppPageScaffold(
          title: '${group.subject} - ${group.name}',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ScheduleCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '${group.year.label} · ${group.students.length} طالب',
                      style: AppFonts.bodyMedium.copyWith(
                        color: palette.textSecondary,
                      ),
                    ),
                    verticalSpace(height: 6),
                    Text(
                      'المحصّل $collected من $expected ${PaymentsContent.currency}',
                      style: AppFonts.titleMedium.copyWith(
                        color: palette.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              verticalSpace(height: 14),
              ScheduleMonthNav(
                label: DateFormatter.monthYear(_month),
                onPrevious: () => _shift(-1),
                onNext: () => _shift(1),
                onPickDate: _pickMonth,
              ),
              verticalSpace(height: 14),
              PaymentsSummaryRow(
                summary: summary,
                selected: _status,
                onSelect: (status) => setState(
                  () => _status = status == _status ? null : status,
                ),
              ),
              verticalSpace(height: 16),
              if (group.students.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.h),
                  child: Text(
                    'لا يوجد طلاب في هذه المجموعة بعد',
                    textAlign: TextAlign.center,
                    style: AppFonts.bodyMedium.copyWith(
                      color: palette.textSecondary,
                    ),
                  ),
                )
              else if (entries.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.h),
                  child: Text(
                    PaymentsContent.noResults,
                    textAlign: TextAlign.center,
                    style: AppFonts.bodyMedium.copyWith(
                      color: palette.textSecondary,
                    ),
                  ),
                )
              else
                for (final entry in entries)
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: GroupStudentTile(
                      key: ValueKey(entry.studentId),
                      entry: entry,
                      todayStatus: attendance.statusOf(entry.studentId, today),
                      summary: attendance.summaryOf(entry.studentId, _month),
                      onMark: (status) => attendance.mark(
                        studentId: entry.studentId,
                        groupId: group.id,
                        date: today,
                        status: status,
                      ),
                      onPayments: () => StudentPaymentSheet.show(
                        context,
                        entry.studentId,
                        _month,
                      ),
                      onAttendance: () => StudentAttendanceSheet.show(
                        context,
                        groupId: group.id,
                        studentId: entry.studentId,
                      ),
                    ),
                  ),
            ],
          ),
        );
      },
    );
  }
}
