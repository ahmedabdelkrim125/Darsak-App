import 'package:flutter/material.dart';
import '../../../../core/helper/responsive_extension.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import '../../data/payments_icons.dart';

class PaymentsEmpty extends StatelessWidget {
  const PaymentsEmpty({
    super.key,
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: palette.background,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56.r,
            height: 56.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: palette.primary.withValues(alpha: 0.1),
            ),
            child: Icon(
              PaymentsIcons.wallet,
              size: 28.r,
              color: palette.primary,
            ),
          ),
          verticalSpace(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppFonts.titleMedium.copyWith(color: palette.textPrimary),
          ),
          verticalSpace(height: 4),
          Text(
            description,
            textAlign: TextAlign.center,
            style: AppFonts.bodySmall.copyWith(
              color: palette.textSecondary,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
