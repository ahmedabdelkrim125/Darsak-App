import 'package:flutter/material.dart';
import '../theme/app_fonts.dart';
import '../theme/app_palette.dart';
import 'app_pressable.dart';
import '../helper/responsive_extension.dart';

class AppCheckbox extends StatelessWidget {
  const AppCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.labelStyle,
    this.size,
    this.radius,
    this.activeColor,
    this.checkColor,
    this.borderColor,
    this.borderWidth,
    this.gap,
    this.enabled = true,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final TextStyle? labelStyle;
  final double? size;
  final double? radius;
  final Color? activeColor;
  final Color? checkColor;
  final Color? borderColor;
  final double? borderWidth;
  final double? gap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final boxSize = size ?? 22.r;
    final active = activeColor ?? palette.primary;
    final interactive = enabled && onChanged != null;

    final box = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      width: boxSize,
      height: boxSize,
      decoration: BoxDecoration(
        color: value ? active : Colors.transparent,
        borderRadius: BorderRadius.circular(radius ?? 6.r),
        border: Border.all(
          color: value
              ? active
              : (borderColor ?? palette.primary.withValues(alpha: 0.45)),
          width: borderWidth ?? 1.5,
        ),
      ),
      child: AnimatedScale(
        scale: value ? 1 : 0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutBack,
        child: Icon(
          Icons.check_rounded,
          size: boxSize * 0.7,
          color: checkColor ?? palette.onPrimary,
        ),
      ),
    );

    return Semantics(
      checked: value,
      child: AppPressable(
        onTap: interactive ? () => onChanged!(!value) : null,
        pressedScale: 0.95,
        haptic: false,
        child: Opacity(
          opacity: enabled ? 1 : 0.5,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              box,
              if (label != null) ...[
                SizedBox(width: gap ?? 10.w),
                Text(
                  label!,
                  style:
                      labelStyle ??
                      AppFonts.bodyMedium.copyWith(color: palette.textPrimary),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
