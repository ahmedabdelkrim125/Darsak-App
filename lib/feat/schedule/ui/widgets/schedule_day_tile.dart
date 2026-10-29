import 'package:flutter/material.dart';
import '../../../../core/const/week_days.dart';
import '../../../../core/helper/responsive_extension.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/app_pressable.dart';

class ScheduleDayTile extends StatelessWidget {
  const ScheduleDayTile({
    super.key,
    required this.date,
    required this.selected,
    required this.isToday,
    required this.hasLessons,
    required this.onTap,
    this.compact = false,
  });

  final DateTime date;
  final bool selected;
  final bool isToday;
  final bool hasLessons;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final radius = BorderRadius.circular(compact ? 14.r : 18.r);

    return AppPressable(
      onTap: onTap,
      pressedScale: 0.94,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(vertical: compact ? 8.h : 10.h),
        decoration: BoxDecoration(
          color: selected ? palette.primary : palette.background,
          borderRadius: radius,
          border: isToday && !selected
              ? Border.all(
                  color: palette.primary.withValues(alpha: 0.5),
                  width: 1.5,
                )
              : null,
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: palette.primary.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!compact) ...[
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  WeekDays.label(date.weekday),
                  style: AppFonts.bodySmall.copyWith(
                    color: selected ? palette.onPrimary : palette.textSecondary,
                    fontSize: 11.sp,
                  ),
                ),
              ),
              verticalSpace(height: 4),
            ],
            Text(
              '${date.day}',
              style: AppFonts.titleMedium.copyWith(
                color: selected ? palette.onPrimary : palette.textPrimary,
                fontSize: compact ? 14.sp : 18.sp,
              ),
            ),
            verticalSpace(height: 4),
            Container(
              width: 5.r,
              height: 5.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: hasLessons
                    ? (selected ? palette.onPrimary : palette.accent)
                    : Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
