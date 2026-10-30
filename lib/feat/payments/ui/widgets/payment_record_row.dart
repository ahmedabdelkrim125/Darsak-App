import 'package:flutter/material.dart';
import '../../../../core/helper/date_formatter.dart';
import '../../../../core/helper/responsive_extension.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/app_pressable.dart';
import '../../data/models/payment_record.dart';
import '../../data/payments_content.dart';
import '../../data/payments_icons.dart';

class PaymentRecordRow extends StatefulWidget {
  const PaymentRecordRow({
    super.key,
    required this.record,
    required this.onDelete,
  });

  final PaymentRecord record;
  final VoidCallback onDelete;

  @override
  State<PaymentRecordRow> createState() => _PaymentRecordRowState();
}

class _PaymentRecordRowState extends State<PaymentRecordRow> {
  bool _confirming = false;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final record = widget.record;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: palette.surface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: _confirming
          ? Row(
              children: [
                Expanded(
                  child: Text(
                    'حذف هذه الدفعة؟',
                    style: AppFonts.bodyMedium.copyWith(color: palette.error),
                  ),
                ),
                AppPressable(
                  onTap: () => setState(() => _confirming = false),
                  pressedScale: 0.9,
                  child: Text(
                    'إلغاء',
                    style: AppFonts.bodyMedium.copyWith(
                      color: palette.textSecondary,
                    ),
                  ),
                ),
                horizontalSpace(width: 14),
                AppPressable(
                  onTap: widget.onDelete,
                  pressedScale: 0.9,
                  child: Text(
                    'حذف',
                    style: AppFonts.bodyMedium.copyWith(color: palette.error),
                  ),
                ),
              ],
            )
          : Row(
              children: [
                Icon(
                  PaymentsIcons.calendar,
                  size: 18.r,
                  color: palette.primary,
                ),
                horizontalSpace(width: 8),
                Expanded(
                  child: Text(
                    DateFormatter.shortDate(record.paidAt),
                    style: AppFonts.bodyMedium.copyWith(
                      color: palette.textPrimary,
                    ),
                  ),
                ),
                Text(
                  '${record.amount} ${PaymentsContent.currency}',
                  style: AppFonts.bodyMedium.copyWith(color: palette.primary),
                ),
                horizontalSpace(width: 12),
                AppPressable(
                  onTap: () => setState(() => _confirming = true),
                  pressedScale: 0.85,
                  child: Icon(
                    PaymentsIcons.delete,
                    size: 20.r,
                    color: palette.textSecondary,
                  ),
                ),
              ],
            ),
    );
  }
}
