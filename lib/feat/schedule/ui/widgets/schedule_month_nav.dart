import 'package:flutter/material.dart';
import '../../../../core/helper/responsive_extension.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/app_pressable.dart';
import '../../data/schedule_icons.dart';

class ScheduleMonthNav extends StatelessWidget {
  const ScheduleMonthNav({
    super.key,
    required this.label,
    required this.onPrevious,
    required this.onNext,
    required this.onPickDate,
  });

  final String label;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onPickDate;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      height: 44.h,
      decoration: BoxDecoration(
        color: palette.background,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: palette.primary.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          _NavButton(icon: ScheduleIcons.previous, onTap: onPrevious),
          Expanded(
            child: AppPressable(
              onTap: onPickDate,
              pressedScale: 0.97,
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        label,
                        style: AppFonts.bodyMedium.copyWith(
                          color: palette.textPrimary,
                          fontSize: 14.sp,
                        ),
                      ),
                      horizontalSpace(width: 4),
                      Icon(
                        ScheduleIcons.dropdown,
                        size: 16.r,
                        color: palette.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          _NavButton(icon: ScheduleIcons.next, onTap: onNext),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      pressedScale: 0.85,
      child: SizedBox(
        width: 34.w,
        height: 44.h,
        child: Icon(icon, size: 18.r, color: context.palette.primary),
      ),
    );
  }
}
