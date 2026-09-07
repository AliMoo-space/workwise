import 'package:flutter/material.dart';

class ColorHelper {
  const ColorHelper._();

  static Color? fromHex(String? hex) {
    if (hex == null || hex.isEmpty) return null;

    final value = hex.replaceFirst('#', '');

    return Color(int.parse(value.length == 6 ? 'FF$value' : value, radix: 16));
  }
}
