import 'package:flutter/material.dart';
import '../theme/app_palette.dart';

import '../helper/responsive_extension.dart';

enum AppButtonVariant { primary, accent, dark, soft, outline }

enum AppButtonIconPosition { start, end }

class AppButtonPalette {
  const AppButtonPalette({
    required this.foreground,
    this.color,
    this.border,
    this.shadows = const [],
  });

  final Color foreground;
  final Color? color;
  final BoxBorder? border;
  final List<BoxShadow> shadows;

  factory AppButtonPalette.of(BuildContext context, AppButtonVariant variant) {
    final palette = context.palette;
    return switch (variant) {
      AppButtonVariant.primary => AppButtonPalette(
        foreground: palette.onPrimary,
        color: palette.primary,
        shadows: _glow(palette.primary),
      ),
      AppButtonVariant.accent => AppButtonPalette(
        foreground: Colors.white,
        color: palette.accent,
        shadows: _glow(palette.accent),
      ),
      AppButtonVariant.dark => AppButtonPalette(
        foreground: Colors.white,
        color: palette.strong,
        shadows: _glow(palette.strong),
      ),
      AppButtonVariant.soft => AppButtonPalette(
        foreground: palette.primary,
        color: palette.track,
      ),
      AppButtonVariant.outline => AppButtonPalette(
        foreground: palette.primary,
        border: Border.all(color: palette.primary, width: 1.5),
      ),
    };
  }

  static List<BoxShadow> _glow(Color color) => [
    BoxShadow(
      color: color.withValues(alpha: 0.35),
      blurRadius: 18.r,
      offset: Offset(0, 8.h),
    ),
  ];
}
