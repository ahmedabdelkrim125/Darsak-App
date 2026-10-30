import 'package:flutter/material.dart';
import '../../../../core/helper/responsive_extension.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/app_pressable.dart';
import '../../data/models/payment_group_summary.dart';
import '../../data/models/payment_status.dart';
import '../../data/payment_status_style.dart';
import '../../data/payments_content.dart';

class PaymentsGroupCard extends StatelessWidget {
  const PaymentsGroupCard({
    super.key,
    required this.group,
    required this.onTap,
  });

  final PaymentGroupSummary group;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final progressColor = PaymentStatus.paid.color(palette);

    return AppPressable(
      onTap: onTap,
      pressedScale: 0.98,
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: palette.background,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: palette.primary.withValues(alpha: 0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    group.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppFonts.titleMedium.copyWith(
                      color: palette.textPrimary,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
                horizontalSpace(width: 8),
                Text(
                  '${group.fee} ${PaymentsContent.currency}',
                  style: AppFonts.bodySmall.copyWith(
                    color: palette.primary,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
            verticalSpace(height: 2),
            Text(
              '${group.yearLabel} · ${group.studentsCount} طالب',
              style: AppFonts.bodySmall.copyWith(
                color: palette.textSecondary,
                fontSize: 12.sp,
              ),
            ),
            verticalSpace(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(6.r),
              child: Stack(
                children: [
                  Container(
                    height: 8.h,
                    color: palette.primary.withValues(alpha: 0.1),
                  ),
                  FractionallySizedBox(
                    alignment: AlignmentDirectional.centerStart,
                    widthFactor: group.progress.clamp(0.0, 1.0),
                    child: Container(height: 8.h, color: progressColor),
                  ),
                ],
              ),
            ),
            verticalSpace(height: 8),
            Text(
              'المحصّل ${group.collected} من ${group.expected} ${PaymentsContent.currency}',
              style: AppFonts.bodySmall.copyWith(
                color: palette.textPrimary,
                fontSize: 12.sp,
              ),
            ),
            verticalSpace(height: 10),
            Wrap(
              spacing: 8.w,
              runSpacing: 6.h,
              children: [
                _CountPill(
                  status: PaymentStatus.paid,
                  count: group.paid,
                  label: 'مدفوع',
                ),
                _CountPill(
                  status: PaymentStatus.partial,
                  count: group.partial,
                  label: 'جزئي',
                ),
                _CountPill(
                  status: PaymentStatus.unpaid,
                  count: group.unpaid,
                  label: 'لم يدفع',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CountPill extends StatelessWidget {
  const _CountPill({
    required this.status,
    required this.count,
    required this.label,
  });

  final PaymentStatus status;
  final int count;
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = status.color(context.palette);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        '$label $count',
        style: AppFonts.bodySmall.copyWith(color: color, fontSize: 11.sp),
      ),
    );
  }
}
