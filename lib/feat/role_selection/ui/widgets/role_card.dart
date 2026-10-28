import 'package:flutter/material.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/app_pressable.dart';
import '../../data/models/role_option_model.dart';
import '../../../../core/helper/responsive_extension.dart';

class RoleCard extends StatelessWidget {
  const RoleCard({
    super.key,
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final RoleOptionModel option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final background = selected
        ? Color.alphaBlend(
            palette.primary.withValues(alpha: 0.08),
            palette.surface,
          )
        : palette.surface;

    return AppPressable(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 16.h),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: selected ? palette.primary : palette.track,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14.r),
              child: AspectRatio(
                aspectRatio: 1.05,
                child: Image.asset(option.image, fit: BoxFit.contain),
              ),
            ),
            verticalSpace(height: 12),
            Text(
              option.title,
              textAlign: TextAlign.center,
              style: AppFonts.titleLarge.copyWith(color: palette.textPrimary),
            ),
            verticalSpace(height: 6),
            Text(
              option.description,
              textAlign: TextAlign.center,
              style: AppFonts.bodySmall.copyWith(color: palette.textSecondary),
            ),
            const Spacer(),
            verticalSpace(height: 14),
            _RadioMark(selected: selected),
          ],
        ),
      ),
    );
  }
}

class _RadioMark extends StatelessWidget {
  const _RadioMark({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final size = 26.r;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? palette.primary : Colors.transparent,
        border: Border.all(
          color: selected ? palette.primary : palette.track,
          width: 2,
        ),
      ),
      child: AnimatedScale(
        scale: selected ? 1 : 0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutBack,
        child: Icon(Icons.check_rounded, size: 16.r, color: palette.onPrimary),
      ),
    );
  }
}
