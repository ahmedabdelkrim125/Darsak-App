import 'package:flutter/material.dart';
import '../../../core/helper/date_formatter.dart';
import '../../../core/helper/responsive_extension.dart';
import '../../../core/helper/spacing.dart';
import '../../../core/theme/app_fonts.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/widgets/app_bottom_sheet.dart';
import '../../../core/widgets/app_button.dart';
import '../../classroom/ui/widgets/sheet_label.dart';
import '../data/payments_content.dart';
import '../data/payments_store.dart';
import 'payments_actions.dart';
import 'widgets/payment_record_row.dart';
import 'widgets/payment_status_pill.dart';

class StudentPaymentSheet extends StatelessWidget {
  const StudentPaymentSheet({
    super.key,
    required this.studentId,
    required this.month,
    required this.hostContext,
  });

  final String studentId;
  final DateTime month;
  final BuildContext hostContext;

  static Future<void> show(
    BuildContext context,
    String studentId,
    DateTime month,
  ) {
    return AppBottomSheet.show<void>(
      context,
      title: 'مدفوعات الطالب',
      child: StudentPaymentSheet(
        studentId: studentId,
        month: month,
        hostContext: context,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final store = PaymentsStore.instance;

    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final entry = store.entryOf(studentId, month);
        if (entry == null) return const SizedBox.shrink();
        final records = store.recordsOf(studentId, month);
        final infoStyle = AppFonts.bodyMedium.copyWith(
          color: palette.textSecondary,
        );

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    entry.studentName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppFonts.titleMedium.copyWith(
                      color: palette.textPrimary,
                    ),
                  ),
                ),
                horizontalSpace(width: 8),
                PaymentStatusPill(status: entry.status),
              ],
            ),
            verticalSpace(height: 6),
            Text(
              '${entry.subject} - ${entry.groupName} · ${entry.yearLabel}',
              style: infoStyle,
            ),
            verticalSpace(height: 4),
            Text('عن شهر ${DateFormatter.monthYear(month)}', style: infoStyle),
            verticalSpace(height: 14),
            Text(
              'سعر الشهر: ${entry.fee} ${PaymentsContent.currency}',
              style: infoStyle,
            ),
            Text(
              'المدفوع: ${entry.paid} ${PaymentsContent.currency}',
              style: infoStyle,
            ),
            Text(
              'المتبقي: ${entry.remaining} ${PaymentsContent.currency}',
              style: infoStyle,
            ),
            verticalSpace(height: 18),
            SheetLabel('الدفعات (${records.length})'),
            if (records.isEmpty)
              Padding(
                padding: EdgeInsets.only(bottom: 14.h),
                child: Text(
                  'لا توجد دفعات مسجلة في هذا الشهر',
                  style: AppFonts.bodyMedium.copyWith(
                    color: palette.textPrimary,
                  ),
                ),
              )
            else
              for (final record in records)
                Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: PaymentRecordRow(
                    key: ValueKey(record.id),
                    record: record,
                    onDelete: () => store.deleteRecord(record.id),
                  ),
                ),
            verticalSpace(height: 6),
            if (entry.remaining > 0)
              AppButton(
                label: PaymentsContent.addPayment,
                expanded: true,
                onPressed: () {
                  Navigator.of(context).pop();
                  if (hostContext.mounted) {
                    PaymentsActions.addPayment(
                      hostContext,
                      month,
                      studentId: studentId,
                    );
                  }
                },
              )
            else
              Text(
                'تم سداد هذا الشهر بالكامل',
                textAlign: TextAlign.center,
                style: AppFonts.bodyMedium.copyWith(color: palette.success),
              ),
          ],
        );
      },
    );
  }
}
