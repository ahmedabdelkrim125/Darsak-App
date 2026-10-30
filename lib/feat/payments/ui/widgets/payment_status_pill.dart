import 'package:flutter/material.dart';
import '../../../../core/helper/responsive_extension.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import '../../data/models/payment_status.dart';
import '../../data/payment_status_style.dart';

class PaymentStatusPill extends StatelessWidget {
  const PaymentStatusPill({super.key, required this.status});

  final PaymentStatus status;

  @override
  Widget build(BuildContext context) {
    final color = status.color(context.palette);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 14.r, color: color),
          horizontalSpace(width: 4),
          Text(
            status.label,
            style: AppFonts.bodySmall.copyWith(color: color, fontSize: 11.sp),
          ),
        ],
      ),
    );
  }
}
