import 'package:flutter/material.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/theme/app_palette.dart';
import '../../data/models/payment_status.dart';
import '../../data/models/payments_summary.dart';
import '../../data/payment_status_style.dart';
import '../../data/payments_content.dart';
import '../../data/payments_icons.dart';
import 'payments_stat_card.dart';

class PaymentsSummaryRow extends StatelessWidget {
  const PaymentsSummaryRow({
    super.key,
    required this.summary,
    required this.selected,
    required this.onSelect,
  });

  final PaymentsSummary summary;
  final PaymentStatus? selected;
  final ValueChanged<PaymentStatus?> onSelect;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Row(
      children: [
        Expanded(
          child: PaymentsStatCard(
            icon: PaymentsIcons.studentsBold,
            value: summary.total,
            label: PaymentsContent.statTotal,
            color: palette.primary,
            selected: selected == null,
            onTap: () => onSelect(null),
          ),
        ),
        horizontalSpace(width: 8),
        Expanded(
          child: PaymentsStatCard(
            icon: PaymentStatus.paid.icon,
            value: summary.paid,
            label: PaymentsContent.statPaid,
            color: PaymentStatus.paid.color(palette),
            selected: selected == PaymentStatus.paid,
            onTap: () => onSelect(PaymentStatus.paid),
          ),
        ),
        horizontalSpace(width: 8),
        Expanded(
          child: PaymentsStatCard(
            icon: PaymentStatus.partial.icon,
            value: summary.partial,
            label: PaymentsContent.statPartial,
            color: PaymentStatus.partial.color(palette),
            selected: selected == PaymentStatus.partial,
            onTap: () => onSelect(PaymentStatus.partial),
          ),
        ),
        horizontalSpace(width: 8),
        Expanded(
          child: PaymentsStatCard(
            icon: PaymentStatus.unpaid.icon,
            value: summary.unpaid,
            label: PaymentsContent.statUnpaid,
            color: PaymentStatus.unpaid.color(palette),
            selected: selected == PaymentStatus.unpaid,
            onTap: () => onSelect(PaymentStatus.unpaid),
          ),
        ),
      ],
    );
  }
}
