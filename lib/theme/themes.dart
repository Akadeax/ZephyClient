import 'package:flutter/material.dart';

class ZephyLight {
  static ColorScheme get colorScheme => ColorScheme.light().copyWith(
    primary: Color(0xFFE0875B),
    primaryVariant: Color(0xFFA1522B),
    onPrimary: Colors.white,

    secondary: Color(0xFF3B56A2),
    secondaryVariant: Color(0xFF77B2E9),
    onSecondary: Colors.white,

    background: Colors.white,
    onBackground: Colors.black,
    onSurface: Color(0xFF707070),

    error: Color(0xFFFA3131),
  );

  static ThemeData get theme => ThemeData(
      brightness: Brightness.light,
      colorScheme: colorScheme,
      textTheme: Typography.blackRedmond,
      elevatedButtonTheme: _elevatedButtonThemeData(colorScheme),
  );
}

class ZephyDark {
  static ColorScheme get colorScheme => ColorScheme.dark().copyWith(
    primary: Color(0xFF714079),
    primaryVariant: Color(0xFFB680BF),
    onPrimary: Colors.white,

    secondary: Color(0xFF3B56A2),
    secondaryVariant: Color(0xFF77B2E9),
    onSecondary: Colors.white,

    background: Color(0xFF222222),
    onBackground: Colors.white,
    onSurface: Color(0xFFB2B2B2),
  );

  static ThemeData get theme => ThemeData(
    brightness: Brightness.dark,
    colorScheme: colorScheme,
    textTheme: Typography.whiteRedmond,
    elevatedButtonTheme: _elevatedButtonThemeData(colorScheme),
    scaffoldBackgroundColor: colorScheme.background,
  );
}

_elevatedButtonThemeData(ColorScheme col) {
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      primary: col.primary,
      onPrimary: col.onPrimary,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      )
    ),
  );
}