import 'package:flutter/material.dart';

Stack fadeLayoutBuilder(top, topKey, bottom, bottomKey) {
  return Stack(
    clipBehavior: Clip.none,
    alignment: Alignment.center,
    children: [
      Positioned(
        key: bottomKey,
        child: bottom,
      ),
      Positioned(
        key: topKey,
        child: top,
      ),
    ],
  );
}