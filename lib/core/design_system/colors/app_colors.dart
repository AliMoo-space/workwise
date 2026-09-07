import 'package:flutter/material.dart';

/// App Colors

@immutable
final class AppColors {
  const AppColors._();

  // ===========================================================================
  // Brand
  // ===========================================================================

  /// Main Brand Color
  static const Color primary = Color(0xFF3525CD);

  /// Primary containers, chips and highlighted backgrounds.
  static const Color primaryContainer = Color(0xFF4F46E5);

  /// Text/icons displayed on Primary.
  static const Color onPrimary = Color(0xFFFFFFFF);

  /// Text/icons displayed on Primary Container.
  static const Color onPrimaryContainer = Color(0xFFDAD7FF);

  /// Fixed brand color.
  static const Color primaryFixed = Color(0xFFE2DFFF);

  static const Color primaryFixedDim = Color(0xFFC3C0FF);

  static const Color onPrimaryFixed = Color(0xFF0F0069);

  static const Color onPrimaryFixedVariant = Color(0xFF3323CC);

  // ===========================================================================
  // Secondary
  // ===========================================================================

  static const Color secondary = Color(0xFF545F73);

  static const Color secondaryContainer = Color(0xFFD5E0F8);

  static const Color onSecondary = Color(0xFFFFFFFF);

  static const Color onSecondaryContainer = Color(0xFF586377);

  static const Color secondaryFixed = Color(0xFFD8E3FB);

  static const Color secondaryFixedDim = Color(0xFFBCC7DE);

  static const Color onSecondaryFixed = Color(0xFF111C2D);

  static const Color onSecondaryFixedVariant = Color(0xFF3C475A);

  // ===========================================================================
  // Success / Positive
  // ===========================================================================

  static const Color success = Color(0xFF006E4B);

  static const Color successContainer = Color(0xFF6FFBBE);

  static const Color onSuccess = Color(0xFFFFFFFF);

  static const Color onSuccessContainer = Color(0xFF002113);

  // ===========================================================================
  // Error
  // ===========================================================================

  static const Color error = Color(0xFFBA1A1A);

  static const Color errorContainer = Color(0xFFFFDAD6);

  static const Color onError = Color(0xFFFFFFFF);

  static const Color onErrorContainer = Color(0xFF93000A);

  // ===========================================================================
  // Background
  // ===========================================================================

  /// Application background.
  static const Color background = Color(0xFFFCF8FF);

  /// Text/icons displayed on Background.
  static const Color onBackground = Color(0xFF1B1B24);

  // ===========================================================================
  // Surface
  // ===========================================================================

  /// Default card color.
  static const Color surface = Color(0xFFFCF8FF);

  static const Color surfaceDim = Color(0xFFDCD8E5);

  static const Color surfaceBright = Color(0xFFFCF8FF);

  static const Color surfaceLowest = Color(0xFFFFFFFF);

  static const Color surfaceLow = Color(0xFFF5F2FF);

  static const Color surfaceContainer = Color(0xFFF0ECF9);

  static const Color surfaceHigh = Color(0xFFEAE6F4);

  static const Color surfaceHighest = Color(0xFFE4E1EE);

  static const Color surfaceVariant = Color(0xFFE4E1EE);

  static const Color onSurface = Color(0xFF1B1B24);

  static const Color onSurfaceVariant = Color(0xFF464555);

  static const Color inverseSurface = Color(0xFF302F39);

  static const Color inverseOnSurface = Color(0xFFF3EFFC);

  static const Color inversePrimary = Color(0xFFC3C0FF);

  static const Color surfaceTint = Color(0xFF4D44E3);

  // ===========================================================================
  // Text
  // ===========================================================================

  /// Primary body text.
  static const Color textPrimary = onSurface;

  /// Secondary body text.
  static const Color textSecondary = onSurfaceVariant;

  /// Placeholder text.
  static const Color textHint = Color(0xFF777587);

  /// White text.
  static const Color textInverse = Color(0xFFFFFFFF);

  /// Disabled text.
  static const Color textDisabled = Color(0xFF9E9AAE);

  // ===========================================================================
  // Border
  // ===========================================================================

  static const Color border = Color(0xFFC7C4D8);

  static const Color divider = Color(0xFFC7C4D8);

  static const Color outline = Color(0xFF777587);

  static const Color outlineVariant = Color(0xFFC7C4D8);

  // ===========================================================================
  // States
  // ===========================================================================

  static const Color disabled = Color(0xFFE4E1EE);

  static const Color focus = primary;

  static const Color hover = Color(0xFFF5F2FF);

  static const Color pressed = Color(0xFFEAE6F4);

  static const Color selected = primaryContainer;

  // ===========================================================================
  // Overlay
  // ===========================================================================

  static const Color overlay = Color(0x66000000);

  static const Color scrim = Color(0x99000000);

  // ===========================================================================
  // Common
  // ===========================================================================

  static const Color white = Colors.white;

  static const Color black = Colors.black;

  static const Color transparent = Colors.transparent;
}
