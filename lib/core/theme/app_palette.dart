import 'package:flutter/material.dart';
import 'package:darsak_app/core/theme/app_colors.dart';

@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.background,
    required this.surface,
    required this.primary,
    required this.onPrimary,
    required this.accent,
    required this.strong,
    required this.textPrimary,
    required this.textSecondary,
    required this.track,
  });

  final Color background;
  final Color surface;
  final Color primary;
  final Color onPrimary;
  final Color accent;
  final Color strong;
  final Color textPrimary;
  final Color textSecondary;
  final Color track;

  static const AppPalette light = AppPalette(
    background: Color(0xFFFFFFFF),
    surface: Color(0xFFF7F2FF),
    primary: AppColors.primary,
    onPrimary: Colors.white,
    accent: AppColors.accent,
    strong: AppColors.primaryDark,
    textPrimary: AppColors.textPrimary,
    textSecondary: AppColors.textSecondary,
    track: AppColors.lavender,
  );

  static const AppPalette dark = AppPalette(
    background: Color(0xFF110B1A),
    surface: Color(0xFF1C1229),
    primary: AppColors.primaryLight,
    onPrimary: Color(0xFF1A0B2E),
    accent: AppColors.accent,
    strong: Color(0xFF6B3AA0),
    textPrimary: Color(0xFFF3ECFF),
    textSecondary: Color(0xFFB9A9D1),
    track: Color(0xFF2E1F45),
  );

  @override
  AppPalette copyWith({
    Color? background,
    Color? surface,
    Color? primary,
    Color? onPrimary,
    Color? accent,
    Color? strong,
    Color? textPrimary,
    Color? textSecondary,
    Color? track,
  }) {
    return AppPalette(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      accent: accent ?? this.accent,
      strong: strong ?? this.strong,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      track: track ?? this.track,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      strong: Color.lerp(strong, other.strong, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      track: Color.lerp(track, other.track, t)!,
    );
  }
}

extension AppPaletteContext on BuildContext {
  AppPalette get palette =>
      Theme.of(this).extension<AppPalette>() ?? AppPalette.light;
}
