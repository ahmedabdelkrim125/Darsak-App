import 'package:flutter/material.dart';
import '../../../core/helper/responsive_extension.dart';
import '../../../core/helper/spacing.dart';
import '../../../core/theme/app_fonts.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/widgets/app_bottom_sheet.dart';
import '../../../core/widgets/app_pressable.dart';
import '../../../core/widgets/app_toast.dart';
import '../data/more_icons.dart';

class LanguageSheet extends StatelessWidget {
  const LanguageSheet({super.key});

  static Future<void> show(BuildContext context) {
    return AppBottomSheet.show<void>(
      context,
      title: 'اللغة',
      child: const LanguageSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _LanguageRow(
          label: 'العربية',
          selected: true,
          onTap: () => Navigator.of(context).pop(),
        ),
        verticalSpace(height: 8),
        _LanguageRow(
          label: 'English',
          selected: false,
          tag: 'قريباً',
          onTap: () => AppToast.show(context, 'اللغة الإنجليزية قريباً'),
        ),
      ],
    );
  }
}

class _LanguageRow extends StatelessWidget {
  const _LanguageRow({
    required this.label,
    required this.selected,
    required this.onTap,
    this.tag,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final String? tag;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return AppPressable(
      onTap: onTap,
      pressedScale: 0.98,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: selected
              ? palette.primary.withValues(alpha: 0.1)
              : palette.surface.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: selected ? palette.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppFonts.bodyMedium.copyWith(
                  color: selected ? palette.primary : palette.textPrimary,
                ),
              ),
            ),
            if (tag != null)
              Text(
                tag!,
                style: AppFonts.bodySmall.copyWith(
                  color: palette.textSecondary,
                ),
              ),
            if (selected)
              Icon(MoreIcons.check, size: 22.r, color: palette.primary),
          ],
        ),
      ),
    );
  }
}
