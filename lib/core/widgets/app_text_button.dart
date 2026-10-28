import 'package:flutter/material.dart';
import '../theme/app_fonts.dart';
import '../theme/app_palette.dart';
import 'app_button_style.dart';
import 'app_pressable.dart';
import '../helper/responsive_extension.dart';

class AppTextButton extends StatelessWidget {
  const AppTextButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.iconPosition = AppButtonIconPosition.end,
    this.color,
    this.style,
    this.underlined = false,
    this.padding,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final AppButtonIconPosition iconPosition;
  final Color? color;
  final TextStyle? style;
  final bool underlined;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final foreground = color ?? context.palette.textSecondary;
    final textStyle = (style ?? AppFonts.bodyLarge).copyWith(
      color: foreground,
      decoration: underlined ? TextDecoration.underline : TextDecoration.none,
      decorationColor: foreground,
    );
    final atStart = iconPosition == AppButtonIconPosition.start;
    final iconWidget = icon == null
        ? null
        : Icon(icon, size: 16.r, color: foreground);

    return AppPressable(
      onTap: onPressed,
      pressedScale: 0.93,
      child: Padding(
        padding:
            padding ?? EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (iconWidget != null && atStart) ...[
              iconWidget,
              SizedBox(width: 6.w),
            ],
            Text(label, style: textStyle),
            if (iconWidget != null && !atStart) ...[
              SizedBox(width: 6.w),
              iconWidget,
            ],
          ],
        ),
      ),
    );
  }
}
