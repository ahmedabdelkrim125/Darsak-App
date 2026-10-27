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
    required this.error,
    required this.success,
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
  final Color error;
  final Color success;

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
    error: Color(0xFFE5484D),
    success: Color(0xFF3CCB6A),
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
    error: Color(0xFFFF7A7F),
    success: Color(0xFF4ADE80),
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
    Color? error,
    Color? success,
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
      error: error ?? this.error,
      success: success ?? this.success,
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
      error: Color.lerp(error, other.error, t)!,
      success: Color.lerp(success, other.success, t)!,
    );
  }
}

extension AppPaletteContext on BuildContext {
  AppPalette get palette =>
      Theme.of(this).extension<AppPalette>() ?? AppPalette.light;
}