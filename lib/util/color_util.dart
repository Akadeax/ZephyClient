import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';

RandomColor colorRandomizer = RandomColor();

Color avatarColor(String id) {
  if(id == null || id.length < 3 || id.isEmpty) return Colors.black;

  return Color.fromARGB(
    255,
      id.codeUnitAt(id.codeUnits.length - 1),
      id.codeUnitAt(id.codeUnits.length - 11),
      id.codeUnitAt(id.codeUnits.length - 21)
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