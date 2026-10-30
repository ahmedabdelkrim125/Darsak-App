import 'package:flutter/material.dart';
import '../../../core/helper/spacing.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/widgets/app_bottom_sheet.dart';
import '../../../core/widgets/app_toast.dart';
import '../../classroom/ui/widgets/classroom_action_row.dart';
import '../data/models/payment_entry.dart';
import '../data/payments_content.dart';
import '../data/payments_icons.dart';
import '../data/payments_store.dart';
import 'payments_actions.dart';
import 'student_payment_sheet.dart';

class PaymentActionsSheet extends StatelessWidget {
  const PaymentActionsSheet({
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
      title: 'خيارات الدفع',
      child: PaymentActionsSheet(
        studentId: studentId,
        month: month,
        hostContext: context,
      ),
    );
  }

  void _payAll(BuildContext context) {
    final error = PaymentsStore.instance.payRemaining(
      studentId: studentId,
      month: month,
      paidAt: DateTime.now(),
    );
    AppToast.show(context, error ?? 'تم تسجيل الدفع بالكامل');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final PaymentEntry? entry = PaymentsStore.instance.entryOf(
      studentId,
      month,
    );
    if (entry == null) return const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (entry.remaining > 0) ...[
          ClassroomActionRow(
            icon: PaymentsIcons.addPayment,
            label: PaymentsContent.addPayment,
            color: palette.textPrimary,
            onTap: () {
              Navigator.of(context).pop();
              if (hostContext.mounted) {
                PaymentsActions.addPayment(
                  hostContext,
                  month,
                  studentId: studentId,
                );
              }
            },
          ),
          verticalSpace(height: 8),
          ClassroomActionRow(
            icon: PaymentsIcons.payFull,
            label:
                'تسجيل دفع كامل (${entry.remaining} ${PaymentsContent.currency})',
            color: palette.success,
            onTap: () => _payAll(context),
          ),
          verticalSpace(height: 8),
        ],
        ClassroomActionRow(
          icon: PaymentsIcons.details,
          label: 'عرض المدفوعات',
          color: palette.textPrimary,
          onTap: () {
            Navigator.of(context).pop();
            if (hostContext.mounted) {
              StudentPaymentSheet.show(hostContext, studentId, month);
            }
          },
        ),
      ],
    );
  }
}
