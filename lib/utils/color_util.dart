import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';

RandomColor colorRandomizer = RandomColor();

Color get rndChannelIconColor {
  return colorRandomizer.randomColor(
      colorHue: ColorHue.blue,
      colorSaturation: ColorSaturation.highSaturation,
      colorBrightness: ColorBrightness.light
  );
}