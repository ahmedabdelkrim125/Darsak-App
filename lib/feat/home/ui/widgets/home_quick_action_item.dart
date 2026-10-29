import 'package:flutter/material.dart';
import '../../../../core/helper/responsive_extension.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/app_pressable.dart';
import '../../data/models/home_quick_action_model.dart';

class HomeQuickActionItem extends StatelessWidget {
  const HomeQuickActionItem({
    super.key,
    required this.action,
    required this.onTap,
  });

  final HomeQuickActionModel action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final tone = action.tone.resolve(palette);

    return AppPressable(
      onTap: onTap,
      pressedScale: 0.94,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: palette.surface.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(color: palette.primary.withValues(alpha: 0.06)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50.r,
              height: 50.r,
              decoration: BoxDecoration(
                color: tone.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(action.icon, size: 28.r, color: tone),
            ),
            verticalSpace(height: 10),
            SizedBox(
              width: double.infinity,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  action.label,
                  maxLines: 1,
                  style: AppFonts.bodySmall.copyWith(
                    color: palette.textPrimary,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
