import 'package:flutter/material.dart';
import '../../../../core/helper/responsive_extension.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/app_pressable.dart';
import '../../../attendance/data/models/attendance_status.dart';
import '../../../attendance/data/models/attendance_summary.dart';
import '../../data/models/payment_entry.dart';
import '../../data/models/payment_status.dart';
import '../../data/payments_content.dart';
import 'group_attendance_chip.dart';
import 'payment_status_pill.dart';

class GroupStudentTile extends StatelessWidget {
  const GroupStudentTile({
    super.key,
    required this.entry,
    required this.todayStatus,
    required this.summary,
    required this.onMark,
    required this.onPayments,
    required this.onAttendance,
  });

  final PaymentEntry entry;
  final AttendanceStatus? todayStatus;
  final AttendanceSummary summary;
  final ValueChanged<AttendanceStatus> onMark;
  final VoidCallback onPayments;
  final VoidCallback onAttendance;

  String get _amountText {
    if (entry.status == PaymentStatus.paid) {
      return 'دفع ${entry.fee} ${PaymentsContent.currency}';
    }
    if (entry.status == PaymentStatus.partial) {
      return 'دفع ${entry.paid} من ${entry.fee} ${PaymentsContent.currency}';
    }
    return 'المطلوب ${entry.fee} ${PaymentsContent.currency}';
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final name = entry.studentName.trim();
    final initial = name.isEmpty ? '؟' : String.fromCharCode(name.runes.first);
    final smallStyle = AppFonts.bodySmall.copyWith(
      color: palette.textSecondary,
      fontSize: 12.sp,
    );

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: palette.background,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: palette.primary.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 40.r,
                height: 40.r,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: palette.primary.withValues(alpha: 0.12),
                ),
                child: Text(
                  initial,
                  style: AppFonts.titleMedium.copyWith(color: palette.primary),
                ),
              ),
              horizontalSpace(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.studentName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppFonts.titleMedium.copyWith(
                        color: palette.textPrimary,
                        fontSize: 15.sp,
                      ),
                    ),
                    verticalSpace(height: 2),
                    Text(
                      _amountText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: smallStyle,
                    ),
                  ],
                ),
              ),
              horizontalSpace(width: 8),
              PaymentStatusPill(status: entry.status),
            ],
          ),
          verticalSpace(height: 10),
          Text(
            'هذا الشهر: حضور ${summary.present} · تأخير ${summary.delayed} · غياب ${summary.absent}',
            style: smallStyle,
          ),
          verticalSpace(height: 8),
          Row(
            children: [
              for (final status in AttendanceStatus.values) ...[
                if (status != AttendanceStatus.values.first)
                  horizontalSpace(width: 6),
                Expanded(
                  child: GroupAttendanceChip(
                    status: status,
                    selected: todayStatus == status,
                    onTap: () => onMark(status),
                  ),
                ),
              ],
            ],
          ),
          verticalSpace(height: 8),
          Row(
            children: [
              Expanded(
                child: _LinkButton(label: 'المدفوعات', onTap: onPayments),
              ),
              horizontalSpace(width: 8),
              Expanded(
                child: _LinkButton(label: 'سجل الحضور', onTap: onAttendance),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LinkButton extends StatelessWidget {
  const _LinkButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return AppPressable(
      onTap: onTap,
      pressedScale: 0.96,
      child: Container(
        height: 36.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: palette.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Text(
          label,
          style: AppFonts.bodySmall.copyWith(
            color: palette.primary,
            fontSize: 12.sp,
          ),
        ),
      ),
    );
  }
}
