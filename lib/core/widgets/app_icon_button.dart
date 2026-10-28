import 'package:flutter/material.dart';
import 'app_button_style.dart';
import 'app_pressable.dart';

import '../helper/responsive_extension.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.variant = AppButtonVariant.soft,
    this.size,
    this.iconSize,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final double? size;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    final palette = AppButtonPalette.of(context, variant);
    final dimension = size ?? 58.h;

    return AppPressable(
      onTap: onPressed,
      pressedScale: 0.85,
      child: Container(
        width: dimension,
        height: dimension,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: palette.color,
          border: palette.border,
          boxShadow: palette.shadows,
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return RotationTransition(
              turns: Tween<double>(begin: 0.75, end: 1).animate(animation),
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: Icon(
            icon,
            key: ValueKey(icon),
            size: iconSize ?? 24.r,
            color: palette.foreground,
          ),
        ),
      ),
    );
  }
}
