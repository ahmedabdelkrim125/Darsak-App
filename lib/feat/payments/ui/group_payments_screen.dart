import 'package:flutter/material.dart';
import '../../../core/helper/date_formatter.dart';
import '../../../core/helper/spacing.dart';
import '../../../core/widgets/app_page_scaffold.dart';
import '../../attendance/data/attendance_store.dart';
import '../../classroom/data/classroom_store.dart';
import '../../schedule/ui/widgets/schedule_month_nav.dart';
import '../data/models/payment_filter.dart';
import '../data/models/payment_status.dart';
import '../data/models/payments_summary.dart';
import '../data/payments_store.dart';
import 'payment_actions_sheet.dart';
import 'payment_filter_sheet.dart';
import 'student_record_screen.dart';
import 'widgets/payments_students_section.dart';
import 'widgets/payments_summary_row.dart';

class GroupPaymentsScreen extends StatefulWidget {
  const GroupPaymentsScreen({
    super.key,
    required this.groupId,
    required this.initialMonth,
  });

  final String groupId;
  final DateTime initialMonth;

  static Future<void> open(
    BuildContext context,
    String groupId,
    DateTime month,
  ) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            GroupPaymentsScreen(groupId: groupId, initialMonth: month),
      ),
    );
  }

  @override
  State<GroupPaymentsScreen> createState() => _GroupPaymentsScreenState();
}

class _GroupPaymentsScreenState extends State<GroupPaymentsScreen> {
  late DateTime _month = DateFormatter.monthStart(widget.initialMonth);
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

  Future<void> _openFilter() async {
    final result = await PaymentFilterSheet.show(
      context,
      PaymentFilter(status: _status, groupId: widget.groupId),
    );
    if (result == null || !mounted) return;
    setState(() => _status = result.status);
  }

  @override
  Widget build(BuildContext context) {
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

        return AppPageScaffold(
          title: '${group.subject} - ${group.name}',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                onSelect: (status) {
                  setState(() => _status = status == _status ? null : status);
                },
              ),
              verticalSpace(height: 14),
              PaymentsStudentsSection(
                entries: entries,
                hasStudents: all.isNotEmpty,
                filterActive: _status != null,
                onFilter: _openFilter,
                onTap: (id) => StudentRecordScreen.open(
                  context,
                  groupId: group.id,
                  studentId: id,
                  month: _month,
                ),
                onMenu: (id) => PaymentActionsSheet.show(context, id, _month),
              ),
            ],
          ),
        );
      },
    );
  }
}
