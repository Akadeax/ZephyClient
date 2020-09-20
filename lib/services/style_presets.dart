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

  static TextStyle get channelNameStyle {
    return TextStyle(
      color: Colors.white,
    );
  }

  static TextStyle get messageTitleStyle {
    return TextStyle(
      color: Colors.grey[800],
      fontSize: 12,
    );
  }

  static TextStyle get messageContentStyle {
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