import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import '../../../../core/helper/responsive_extension.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/app_pressable.dart';
import '../../../attendance/data/attendance_status_style.dart';
import '../../../attendance/data/models/attendance_status.dart';
import '../../data/models/classroom_student.dart';

class ClassroomStudentRow extends StatefulWidget {
  const ClassroomStudentRow({
    super.key,
    required this.student,
    this.onRemove,
    this.onTap,
    this.todayStatus,
  });

  final ClassroomStudent student;
  final VoidCallback? onRemove;
  final VoidCallback? onTap;
  final AttendanceStatus? todayStatus;

  @override
  State<ClassroomStudentRow> createState() => _ClassroomStudentRowState();
}

class _ClassroomStudentRowState extends State<ClassroomStudentRow> {
  bool _confirming = false;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final student = widget.student;
    final status = widget.todayStatus;

    final content = Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: palette.surface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: _confirming
          ? Row(
              children: [
                Expanded(
                  child: Text(
                    'حذف ${student.name}؟',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppFonts.bodyMedium.copyWith(color: palette.error),
                  ),
                ),
                _RowAction(
                  label: 'إلغاء',
                  color: palette.textSecondary,
                  onTap: () => setState(() => _confirming = false),
                ),
                horizontalSpace(width: 14),
                _RowAction(
                  label: 'حذف',
                  color: palette.error,
                  onTap: () => widget.onRemove?.call(),
                ),
              ],
            )
          : Row(
              children: [
                Icon(
                  Icons.person_outline_rounded,
                  size: 22.r,
                  color: palette.primary,
                ),
                horizontalSpace(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        student.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppFonts.bodyMedium.copyWith(
                          color: palette.textPrimary,
                        ),
                      ),
                      if (student.hasAccount)
                        Text(
                          '@${student.username}',
                          textDirection: TextDirection.ltr,
                          style: AppFonts.bodySmall.copyWith(
                            color: palette.primary,
                          ),
                        )
                      else
                        Text(
                          'بدون حساب',
                          style: AppFonts.bodySmall.copyWith(
                            color: palette.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
                if (status != null) ...[
                  horizontalSpace(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: status.color(palette).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      'اليوم: ${status.label}',
                      style: AppFonts.bodySmall.copyWith(
                        color: status.color(palette),
                        fontSize: 11.sp,
                      ),
                    ),
                  ),
                ],
                if (widget.onRemove != null) ...[
                  horizontalSpace(width: 10),
                  AppPressable(
                    onTap: () => setState(() => _confirming = true),
                    pressedScale: 0.85,
                    child: Icon(
                      SolarIconsOutline.trashBinMinimalistic,
                      size: 20.r,
                      color: palette.textSecondary,
                    ),
                  ),
                ],
                if (widget.onTap != null) ...[
                  horizontalSpace(width: 4),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 22.r,
                    color: palette.textSecondary,
                  ),
                ],
              ],
            ),
    );

    if (widget.onTap == null || _confirming) return content;

    return AppPressable(
      onTap: widget.onTap!,
      pressedScale: 0.98,
      child: content,
    );
  }
}

class _RowAction extends StatelessWidget {
  const _RowAction({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      pressedScale: 0.9,
      child: Text(label, style: AppFonts.bodyMedium.copyWith(color: color)),
    );
  }
}
