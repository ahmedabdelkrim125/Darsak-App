import 'package:flutter/material.dart';
import '../../../../core/helper/responsive_extension.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/app_pressable.dart';

class ClassroomChip extends StatelessWidget {
  const ClassroomChip({
    super.key,
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
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: selected
              ? palette.primary
              : palette.track.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: selected
                ? palette.primary
                : palette.primary.withValues(alpha: 0.15),
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: AppFonts.bodyMedium.copyWith(
            color: selected ? palette.onPrimary : palette.textPrimary,
          ),
        ),
      ),
    );
  }
}
