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
    surface: Color(0xFFE8E8E8),
    onSurface: Color(0xFF707070),

    error: Color(0xFFFA3131),
  );

  static get textTheme => Typography.blackRedmond;

  static ThemeData get theme => ThemeData(
    brightness: Brightness.light,
    colorScheme: colorScheme,
    cardColor: Color(0xFFD2D2D2),
    textTheme: textTheme,
    elevatedButtonTheme: _elevatedButtonThemeData(colorScheme),
    snackBarTheme: _snackBarTheme(colorScheme, textTheme),
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

    background: Color(0xFF363738),
    onBackground: Colors.white,
    surface: Color(0xFF494949),
    onSurface: Color(0xFFB2B2B2),
    error: Color(0xFFFF5252),
    onError: Colors.white,
  );

  static get textTheme => Typography.whiteRedmond;

  static ThemeData get theme => ThemeData(
    brightness: Brightness.dark,
    colorScheme: colorScheme,
    cardColor: Color(0xFF2E2F31),
    textTheme: textTheme,
    elevatedButtonTheme: _elevatedButtonThemeData(colorScheme),
    scaffoldBackgroundColor: colorScheme.background,
    snackBarTheme: _snackBarTheme(colorScheme, textTheme),
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

_snackBarTheme(ColorScheme col, TextTheme text) {
  return SnackBarThemeData(
    backgroundColor: col.error,
    contentTextStyle: text.bodyText2.copyWith(
      color: col.onError,
    ),
    elevation: 5,
    behavior: SnackBarBehavior.floating,
  );
}
