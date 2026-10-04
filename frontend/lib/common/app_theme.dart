import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData light = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: const Color(0xFF6F4E37), // coffee brown
    scaffoldBackgroundColor: const Color(0xFFFAF6F1),
  );
}
