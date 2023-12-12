import 'package:flutter/material.dart';

class ColorPalette {
  static final ColorPalette _instance = ColorPalette._internal();

  factory ColorPalette() {
    return _instance;
  }

  ColorPalette._internal();

  static const purpel = Color.fromARGB(255, 188, 111, 241);
  static const purpel2 = Color.fromARGB(255, 137, 44, 220);
  static const purpel3 = Color.fromARGB(255, 82, 5, 123);
}
