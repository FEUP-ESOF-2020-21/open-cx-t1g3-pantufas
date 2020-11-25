import 'package:flutter/material.dart';

class MyAppTheme {
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

  Color accent1 = Colors.black;

  ThemeData get themeData {
    TextTheme textTheme = ThemeData.dark().textTheme;
    Color txtColor = textTheme.bodyText1.color;
    ColorScheme colorScheme = ColorScheme.fromSwatch(
      accentColor: swatch.shade50,
      backgroundColor: swatch.shade800,
      brightness: Brightness.dark,
      cardColor: swatch.shade500,
      errorColor: Colors.red,
      primaryColorDark: swatch.shade800,
      primarySwatch: swatch,
    );

    var t =
        ThemeData.from(textTheme: textTheme, colorScheme: colorScheme).copyWith(
      buttonColor: accent1,
      cursorColor: accent1,
      highlightColor: accent1,
      primaryColor: swatch.shade800,
      scaffoldBackgroundColor: swatch.shade900,
      toggleableActiveColor: accent1,
    );
    return t;
  }
}
