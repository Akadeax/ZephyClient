import 'package:flutter/material.dart';

class ZephyLogo extends StatelessWidget {
  final double size;
  final Color color;

  const ZephyLogo({this.size = 50, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      child: Image(
        height: size - 2,
        width: size - 2,
        fit: BoxFit.fill,
        image: AssetImage("assets/images/zephy_logo.png"),
        color: color,
      ),
    );
  }
}
