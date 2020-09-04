import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';

class StylePresets {
  static RandomColor colorRandomizer = RandomColor();

  static Color get channelIconColor {
    return colorRandomizer.randomColor(
        colorHue: ColorHue.blue,
        colorSaturation: ColorSaturation.highSaturation,
        colorBrightness: ColorBrightness.light
    );
  }

  static TextStyle get messageStyle {
    return TextStyle(
      color: Colors.black,
      fontSize: 15,
    );
  }

  static TextStyle get channelIconStyle {
    return TextStyle(
      color: Colors.white,
      fontSize: 18,
    );
  }
}