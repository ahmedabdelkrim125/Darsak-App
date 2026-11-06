import 'package:flutter/material.dart';
import '../../../core/helper/date_formatter.dart';
import '../../../core/helper/responsive_extension.dart';
import '../../../core/helper/spacing.dart';
import '../../../core/theme/app_fonts.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_page_scaffold.dart';
import '../../attendance/ui/student_attendance_sheet.dart';
import '../../classroom/data/classroom_store.dart';
import '../../classroom/ui/widgets/sheet_label.dart';
import '../../schedule/ui/widgets/schedule_month_nav.dart';
import '../data/models/payment_entry.dart';
import '../data/models/payment_status.dart';
import '../data/payments_store.dart';
import 'student_payment_sheet.dart';

class StudentRecordScreen extends StatefulWidget {
  const StudentRecordScreen({
    super.key,
    required this.groupId,
    required this.studentId,
    required this.initialMonth,
  });

  final String groupId;
  final String studentId;
  final DateTime initialMonth;

  static Future<void> open(
    BuildContext context, {
    required String groupId,
    required String studentId,
    required DateTime month,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => StudentRecordScreen(
          groupId: groupId,
          studentId: studentId,
          initialMonth: month,
        ),
      ),
    );
  }

  @override
  State<StudentRecordScreen> createState() => _StudentRecordScreenState();
}

class _StudentRecordScreenState extends State<StudentRecordScreen> {
  late DateTime _month = DateFormatter.monthStart(widget.initialMonth);

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
    final classroom = ClassroomStore.instance;
    final payments = PaymentsStore.instance;

    return ListenableBuilder(
      listenable: Listenable.merge([classroom, payments]),
      builder: (context, _) {
        final group = classroom.groupById(widget.groupId);
        final entry = payments.entryOf(widget.studentId, _month);
        if (group == null || entry == null) {
          return const AppPageScaffold(
            title: 'سجل الطالب',
            child: SizedBox.shrink(),
          );
        }

        return AppPageScaffold(
          title: entry.studentName,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SheetLabel('المدفوعات'),
              ScheduleMonthNav(
                label: DateFormatter.monthYear(_month),
                onPrevious: () => _shift(-1),
                onNext: () => _shift(1),
                onPickDate: _pickMonth,
              ),
              verticalSpace(height: 12),
              _PaymentCard(
                entry: entry,
                onPay: () =>
                    StudentPaymentSheet.show(context, entry.studentId, _month),
              ),
              verticalSpace(height: 22),
              StudentAttendanceSheet(
                groupId: widget.groupId,
                studentId: widget.studentId,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PaymentCard extends StatelessWidget {
  const _PaymentCard({required this.entry, required this.onPay});

  final PaymentEntry entry;
  final VoidCallback onPay;

  Color _color(AppPalette palette) {
    return switch (entry.status) {
      PaymentStatus.paid => palette.success,
      PaymentStatus.partial => const Color(0xFFF59E0B),
      PaymentStatus.unpaid => palette.error,
    };
  }

  String get _label {
    return switch (entry.status) {
      PaymentStatus.paid => 'مدفوع',
      PaymentStatus.partial => 'جزئي',
      PaymentStatus.unpaid => 'لم يدفع',
    };
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final color = _color(palette);
    final ratio = entry.fee == 0
        ? 0.0
        : (entry.paid / entry.fee).clamp(0.0, 1.0);

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: palette.surface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: palette.primary.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${entry.subject} - ${entry.groupName}',
                  style: AppFonts.bodyMedium.copyWith(
                    color: palette.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  _label,
                  style: AppFonts.bodySmall.copyWith(color: color),
                ),
              ),
            ],
          ),
          verticalSpace(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 8.h,
              color: color,
              backgroundColor: color.withValues(alpha: 0.15),
            ),
          ),
          verticalSpace(height: 12),
          _Line(label: 'المدفوع', value: '${entry.paid} جنيه'),
          _Line(label: 'المطلوب', value: '${entry.fee} جنيه'),
          _Line(label: 'المتبقي', value: '${entry.remaining} جنيه'),
          verticalSpace(height: 12),
          AppButton(label: 'تسجيل ومراجعة الدفعات', expanded: true, onPressed: onPay),
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        children: [
          Text(
            label,
            style: AppFonts.bodyMedium.copyWith(color: palette.textSecondary),
          ),
          const Spacer(),
          Text(
            value,
            style: AppFonts.bodyMedium.copyWith(color: palette.textPrimary),
          ),
        ],
      ),
    );
  }
}
