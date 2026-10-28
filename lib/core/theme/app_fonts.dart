import 'package:flutter/material.dart';
import 'app_colors.dart';
import '../helper/responsive_extension.dart';

class AppFonts {
  AppFonts._();

  static const String primary = 'IBMPlexArabic';

  static TextStyle get displayLarge => TextStyle(
    fontFamily: primary,
    fontSize: 32.sp,
    fontWeight: FontWeight.w500,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  static TextStyle get headlineLarge => TextStyle(
    fontFamily: primary,
    fontSize: 26.sp,
    fontWeight: FontWeight.w500,
    height: 1.35,
    color: AppColors.textPrimary,
  );

  static TextStyle get headlineMedium => TextStyle(
    fontFamily: primary,
    fontSize: 22.sp,
    fontWeight: FontWeight.w500,
    height: 1.35,
    color: AppColors.textPrimary,
  );

  static TextStyle get titleLarge => TextStyle(
    fontFamily: primary,
    fontSize: 20.sp,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  static TextStyle get titleMedium => TextStyle(
    fontFamily: primary,
    fontSize: 17.sp,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodyLarge => TextStyle(
    fontFamily: primary,
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodyMedium => TextStyle(
    fontFamily: primary,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: AppColors.textSecondary,
  );

  static TextStyle get bodySmall => TextStyle(
    fontFamily: primary,
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textSecondary,
  );

  static TextStyle get labelLarge => TextStyle(
    fontFamily: primary,
    fontSize: 15.sp,
    fontWeight: FontWeight.w500,
    height: 1.3,
    color: AppColors.white,
  );

  static TextStyle get labelMedium => TextStyle(
    fontFamily: primary,
    fontSize: 13.sp,
    fontWeight: FontWeight.w500,
    height: 1.3,
    color: AppColors.primary,
  );
}
