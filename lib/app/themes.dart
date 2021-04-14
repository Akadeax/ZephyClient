import 'package:flutter/material.dart';

class ZephyDark {
  static TextTheme textTheme = Typography.whiteRedmond.copyWith(
    button: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
  );
  static ColorScheme get colorScheme => ColorScheme.dark();

  static ThemeData get theme => ThemeData(
      brightness: Brightness.dark,
      colorScheme: colorScheme,

      textTheme: textTheme,
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(colorScheme.secondary),
              foregroundColor: MaterialStateProperty.all(colorScheme.onSecondary),
              padding: MaterialStateProperty.all(EdgeInsets.all(18)),
              textStyle: MaterialStateProperty.all(textTheme.button)
          )
      )
  );
}