import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get colors => theme.colorScheme;

  TextTheme get textTheme => theme.textTheme;

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  Size get screenSize => mediaQuery.size;

  double get screenWidth => screenSize.width;

  double get screenHeight => screenSize.height;

  bool get isKeyboardOpen => mediaQuery.viewInsets.bottom > 0;

  bool get isDarkMode => theme.brightness == Brightness.dark;

  bool get isLandscape =>
      mediaQuery.orientation == Orientation.landscape;

  void hideKeyboard() {
    FocusScope.of(this).unfocus();
  }
}