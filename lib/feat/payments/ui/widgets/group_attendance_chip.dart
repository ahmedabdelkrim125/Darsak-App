import 'package:flutter/material.dart';
import '../../../../core/helper/responsive_extension.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/app_pressable.dart';
import '../../../attendance/data/attendance_status_style.dart';
import '../../../attendance/data/models/attendance_status.dart';

class GroupAttendanceChip extends StatelessWidget {
  const GroupAttendanceChip({
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
      pressedScale: 0.95,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 38.h,
        decoration: BoxDecoration(
          color: selected
              ? color.withValues(alpha: 0.14)
              : palette.surface.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: selected ? color : palette.primary.withValues(alpha: 0.08),
            width: 1.2,
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  status.icon,
                  size: 18.r,
                  color: selected ? color : palette.textSecondary,
                ),
                horizontalSpace(width: 4),
                Text(
                  status.label,
                  style: AppFonts.bodySmall.copyWith(
                    fontSize: 12.sp,
                    color: selected ? color : palette.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
