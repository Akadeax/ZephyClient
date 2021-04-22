import 'package:flutter/material.dart';

class CircleDecorationPainter extends CustomPainter {
  final ThemeData theme;
  CircleDecorationPainter({@required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = theme.colorScheme.secondary;
    canvas.drawCircle(Offset(0, size.height * 0.8), 100, paint);
    paint.color = theme.colorScheme.secondaryVariant;
    canvas.drawCircle(Offset(130, size.height * 1.6), 100, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}