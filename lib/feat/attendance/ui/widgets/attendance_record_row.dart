import 'package:flutter/material.dart';
import '../../../../core/const/week_days.dart';
import '../../../../core/helper/date_formatter.dart';
import '../../../../core/helper/responsive_extension.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/app_pressable.dart';
import '../../data/attendance_status_style.dart';
import '../../data/models/attendance_record.dart';

class AttendanceRecordRow extends StatelessWidget {
  const AttendanceRecordRow({
    super.key,
    required this.record,
    required this.selected,
    required this.onTap,
  });

  final AttendanceRecord record;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final color = record.status.color(palette);

    return AppPressable(
      onTap: onTap,
      pressedScale: 0.98,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: selected
              ? palette.primary.withValues(alpha: 0.08)
              : palette.surface.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: selected
                ? palette.primary.withValues(alpha: 0.3)
                : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Icon(record.status.icon, size: 22.r, color: color),
            horizontalSpace(width: 10),
            Expanded(
              child: Text(
                '${WeekDays.label(record.date.weekday)} · ${DateFormatter.shortDate(record.date)}',
                style: AppFonts.bodyMedium.copyWith(
                  color: palette.textPrimary,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                record.status.label,
                style: AppFonts.bodySmall.copyWith(
                  color: color,
                  fontSize: 11.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
