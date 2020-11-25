import 'package:flutter/material.dart';

class MyTheme {
  final swatch = const MaterialColor(0xFF202124, const <int, Color>{
    50: const Color(0xFF32674C),
    100: const Color(0xFFCFD3D8),
    200: const Color(0xFFABAFB1),
    300: const Color(0xFF929597),
    400: const Color(0xFF6D7172),
    500: const Color(0xFF4E5254),
    600: const Color(0xFF3c4042),
    700: const Color(0xFF202124),
    800: const Color(0xFF1D1D1D),
    900: const Color(0xFF121212),
  });

  ThemeData themeData;

  MyTheme() {
    this.themeData = ThemeData(
      brightness: Brightness.dark,
      primaryColor: swatch.shade800,
      accentColor: swatch.shade800,
      primarySwatch: swatch,
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: swatch,
        primaryColorDark: swatch.shade800,
        accentColor: swatch.shade50,
        cardColor: swatch.shade500,
        backgroundColor: swatch.shade800,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: swatch.shade900,
    );
  }
}
