import 'package:flutter/material.dart';
import '../../../../core/helper/responsive_extension.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/app_pressable.dart';
import '../../data/models/schedule_view_mode.dart';
import '../../data/schedule_content.dart';

class ScheduleViewToggle extends StatelessWidget {
  const ScheduleViewToggle({
    super.key,
    required this.mode,
    required this.onChanged,
  });

  final ScheduleViewMode mode;
  final ValueChanged<ScheduleViewMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      padding: EdgeInsets.all(3.r),
      decoration: BoxDecoration(
        color: palette.background,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: palette.primary.withValues(alpha: 0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Segment(
            label: ScheduleContent.weekLabel,
            selected: mode == ScheduleViewMode.week,
            onTap: () => onChanged(ScheduleViewMode.week),
          ),
          _Segment(
            label: ScheduleContent.monthLabel,
            selected: mode == ScheduleViewMode.month,
            onTap: () => onChanged(ScheduleViewMode.month),
          ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return AppPressable(
      onTap: onTap,
      pressedScale: 0.95,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: selected ? palette.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(13.r),
        ),
        child: Text(
          label,
          style: AppFonts.bodySmall.copyWith(
            color: selected ? palette.onPrimary : palette.textSecondary,
            fontSize: 13.sp,
          ),
        ),
      ),
    );
  }
}
