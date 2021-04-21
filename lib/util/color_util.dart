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

Color darken(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

Color lighten(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

  return hslLight.toColor();
}