import 'package:flutter/material.dart';
import '../../../../core/helper/responsive_extension.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/app_pressable.dart';
import '../../data/attendance_status_style.dart';
import '../../data/models/attendance_status.dart';

class AttendanceStatusButton extends StatelessWidget {
  const AttendanceStatusButton({
    super.key,
    required this.status,
    required this.selected,
    required this.onTap,
  });

  final AttendanceStatus status;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final color = status.color(palette);

    return AppPressable(
      onTap: onTap,
      pressedScale: 0.96,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        height: 58.h,
        decoration: BoxDecoration(
          color: selected
              ? color.withValues(alpha: 0.14)
              : palette.surface.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: selected ? color : palette.primary.withValues(alpha: 0.08),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              status.icon,
              size: 24.r,
              color: selected ? color : palette.textSecondary,
            ),
            horizontalSpace(width: 8),
            Text(
              status.label,
              style: AppFonts.titleMedium.copyWith(
                fontSize: 16.sp,
                color: selected ? color : palette.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}