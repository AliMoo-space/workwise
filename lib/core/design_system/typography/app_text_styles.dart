import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../colors/app_colors.dart';

@immutable
final class AppTextStyles {
  const AppTextStyles._();

  // ===========================================================================
  // Font Families
  // ===========================================================================

  static const String headingFontFamily = 'Manrope';
  static const String bodyFontFamily = 'Inter';

  // Arabic
  static const String arabicHeadingFontFamily = 'Cairo';
  static const String arabicBodyFontFamily = 'Tajawal';

  // Code
  static const String codeFontFamily = 'JetBrainsMono';

  // ===========================================================================
  // Display
  // ===========================================================================

  static const TextStyle displayLarge = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 40 / 32,
    color: AppColors.textPrimary,
  );

  static TextStyle displayMedium = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: 25.sp,
    fontWeight: FontWeight.w700,
    height: 40 / 32.h,
    color: AppColors.textPrimary,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 36 / 28,
    color: AppColors.textPrimary,
  );

  // ===========================================================================
  // Headlines
  // ===========================================================================

  static const TextStyle headlineLarge = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 36 / 28,
    color: AppColors.textPrimary,
  );

  static TextStyle headlineMedium = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    height: 32 / 24.h,
    color: AppColors.textPrimary,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 28 / 20,
    color: AppColors.textPrimary,
  );

  // ===========================================================================
  // Titles
  // ===========================================================================

  static TextStyle titleLarge = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    height: 28 / 20,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 24 / 18,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 22 / 16,
    color: AppColors.textPrimary,
  );

  // ===========================================================================
  // Body
  // ===========================================================================

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: bodyFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyMedium = TextStyle(
    fontFamily: bodyFontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    height: 20 / 14.h,
    color: AppColors.textPrimary,
  );

  static TextStyle bodySmall = TextStyle(
    fontFamily: bodyFontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    height: 20 / 14.h,
    color: AppColors.textSecondary,
  );

  // ===========================================================================
  // Labels
  // ===========================================================================

  static TextStyle labelLarge = TextStyle(
    fontFamily: bodyFontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    height: 20 / 14.h,
    color: AppColors.textPrimary,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: bodyFontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 18 / 13,
    color: AppColors.textPrimary,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: bodyFontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 16 / 12,
    color: AppColors.textSecondary,
  );

  // ===========================================================================
  // Buttons
  // ===========================================================================

  static const TextStyle button = TextStyle(
    fontFamily: bodyFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 20 / 14,
    color: AppColors.onPrimary,
  );

  static const TextStyle buttonLarge = TextStyle(
    fontFamily: bodyFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 24 / 16,
    color: AppColors.onPrimary,
  );

  // ===========================================================================
  // Inputs
  // ===========================================================================

  static const TextStyle input = TextStyle(
    fontFamily: bodyFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
    color: AppColors.textPrimary,
  );

  static const TextStyle hint = TextStyle(
    fontFamily: bodyFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
    color: AppColors.textHint,
  );

  // ===========================================================================
  // Captions
  // ===========================================================================

  static const TextStyle caption = TextStyle(
    fontFamily: bodyFontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 16 / 12,
    color: AppColors.textSecondary,
  );

  // ===========================================================================
  // Code
  // ===========================================================================

  static const TextStyle code = TextStyle(
    fontFamily: codeFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    color: AppColors.textPrimary,
    fontFeatures: [FontFeature.tabularFigures()],
  );
}
