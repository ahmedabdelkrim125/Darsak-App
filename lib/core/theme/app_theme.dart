import 'package:flutter/material.dart';
import 'package:darsak_app/core/theme/app_colors.dart';
import 'package:darsak_app/core/theme/app_fonts.dart';
import 'package:darsak_app/core/theme/app_palette.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(Brightness.light, AppPalette.light);

  static ThemeData get dark => _build(Brightness.dark, AppPalette.dark);

  static ThemeData _build(Brightness brightness, AppPalette palette) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: AppFonts.primary,
      scaffoldBackgroundColor: palette.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: brightness,
        primary: palette.primary,
        secondary: palette.accent,
        surface: palette.background,
      ),
      extensions: [palette],
    );
  }
}
