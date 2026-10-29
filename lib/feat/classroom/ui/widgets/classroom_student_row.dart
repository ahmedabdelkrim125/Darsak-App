import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import '../../../../core/helper/responsive_extension.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/app_pressable.dart';
import '../../data/models/classroom_student.dart';

class ClassroomStudentRow extends StatefulWidget {
  const ClassroomStudentRow({super.key, required this.student, this.onRemove});

  final ClassroomStudent student;
  final VoidCallback? onRemove;

  @override
  State<ClassroomStudentRow> createState() => _ClassroomStudentRowState();
}

class _ClassroomStudentRowState extends State<ClassroomStudentRow> {
  bool _confirming = false;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final student = widget.student;

    return Container(
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
                  child: Text(
                    student.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppFonts.bodyMedium.copyWith(
                      color: palette.textPrimary,
                    ),
                  ),
                ),
                horizontalSpace(width: 8),
                if (student.hasAccount)
                  Text(
                    '@${student.username}',
                    textDirection: TextDirection.ltr,
                    style: AppFonts.bodySmall.copyWith(color: palette.primary),
                  )
                else
                  Text(
                    'بدون حساب',
                    style: AppFonts.bodySmall.copyWith(
                      color: palette.textSecondary,
                    ),
                  ),
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
              ],
            ),
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
