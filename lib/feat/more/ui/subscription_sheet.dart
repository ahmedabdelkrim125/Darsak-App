import 'package:flutter/material.dart';
import '../../../core/helper/responsive_extension.dart';
import '../../../core/helper/spacing.dart';
import '../../../core/theme/app_fonts.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/widgets/app_bottom_sheet.dart';
import '../../../core/widgets/app_button.dart';
import '../data/more_icons.dart';

class SubscriptionSheet extends StatelessWidget {
  const SubscriptionSheet({super.key});

  static Future<void> show(BuildContext context) {
    return AppBottomSheet.show<void>(
      context,
      title: 'إدارة الاشتراك',
      child: const SubscriptionSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    const amber = Color(0xFFF59E0B);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Container(
            width: 76.r,
            height: 76.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: amber.withValues(alpha: 0.15),
            ),
            child: Icon(MoreIcons.subscription, size: 38.r, color: amber),
          ),
        ),
        verticalSpace(height: 14),
        Text(
          'الباقة الحالية: مجانية',
          textAlign: TextAlign.center,
          style: AppFonts.titleMedium.copyWith(color: palette.textPrimary),
        ),
        verticalSpace(height: 6),
        Text(
          'التطبيق مجاني حالياً، وجميع المميزات متاحة لك دون أي رسوم حتى إشعار آخر.',
          textAlign: TextAlign.center,
          style: AppFonts.bodyMedium.copyWith(
            color: palette.textSecondary,
            height: 1.6,
          ),
        ),
        verticalSpace(height: 18),
        AppButton(
          label: 'حسناً',
          expanded: true,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
