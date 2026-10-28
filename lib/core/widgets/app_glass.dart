import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_palette.dart';
import '../helper/responsive_extension.dart';

class AppGlass extends StatelessWidget {
  const AppGlass({
    super.key,
    required this.child,
    this.radius,
    this.blur = 24,
    this.tint,
    this.tintOpacity,
    this.borderColor,
    this.borderWidth,
    this.shadows,
    this.padding,
    this.sheen = true,
  });

  final Widget child;
  final double? radius;
  final double blur;
  final Color? tint;
  final double? tintOpacity;
  final Color? borderColor;
  final double? borderWidth;
  final List<BoxShadow>? shadows;
  final EdgeInsetsGeometry? padding;
  final bool sheen;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isDark = palette.background.computeLuminance() < 0.5;
    final shape = BorderRadius.circular(radius ?? 24.r);
    final base = (tint ?? palette.surface).withValues(
      alpha: tintOpacity ?? (isDark ? 0.55 : 0.6),
    );
    final line =
        borderColor ?? Colors.white.withValues(alpha: isDark ? 0.14 : 0.85);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: shape,
        boxShadow:
            shadows ??
            [
              BoxShadow(
                color: palette.primary.withValues(alpha: isDark ? 0.22 : 0.14),
                blurRadius: 28.r,
                offset: Offset(0, 10.h),
              ),
            ],
      ),
      child: ClipRRect(
        borderRadius: shape,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: base,
              borderRadius: shape,
              gradient: sheen
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(alpha: isDark ? 0.10 : 0.5),
                        Colors.white.withValues(alpha: 0),
                      ],
                    )
                  : null,
              border: Border.all(color: line, width: borderWidth ?? 1.2),
            ),
            child: padding == null
                ? child
                : Padding(padding: padding!, child: child),
          ),
        ),
      ),
    );
  }
}
