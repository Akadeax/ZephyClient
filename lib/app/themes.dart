import 'package:flutter/material.dart';

ThemeData get darkTheme => ThemeData(
  brightness: Brightness.dark,
  colorScheme: darkColorScheme,

  textTheme: Typography.whiteRedmond,
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(darkColorScheme.primary),
      foregroundColor: MaterialStateProperty.all(darkColorScheme.onPrimary),
      padding: MaterialStateProperty.all(EdgeInsets.all(15)),
    )
  )
);

ColorScheme get darkColorScheme => ColorScheme(
  brightness: Brightness.dark,

  primary: Color(0xFF2858F9),
  primaryVariant: Color(0xFF213366),

  secondary: Color(0xFF345F4D),
  secondaryVariant: Color(0xFF345F4D),

  background: Color(0xFF292F39),
  surface: Color(0xFF323740),
  error: Color(0xFF5B4E43),

  onPrimary: Color(0xFFE3EBFE),
  onSecondary: Color(0xFF3BC86F),
  onBackground: Color(0xFF99A0B2),
  onSurface: Color(0xFF9BA2B4),
  onError: Color(0xFFF2A853),
);

