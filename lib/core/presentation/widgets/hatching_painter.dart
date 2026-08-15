import 'dart:math';

import 'package:flutter/material.dart';

class HatchingPainter extends CustomPainter {
  final double width;
  final double dHeight;
  final double spacing;
  final double angle;

  final Color color;

  const HatchingPainter({
    this.width = 2.0,
    this.dHeight = -4.0,
    this.spacing = 8.0,
    this.angle = pi / 6.0,
    this.color = Colors.black,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..strokeWidth = width
      ..color = color
      ..strokeCap = StrokeCap.round;

    final height = size.height + dHeight;
    final y0 = -dHeight / 2.0;
    final y1 = size.height + dHeight / 2.0;
    final x0 = spacing / 2.0;
    final slope = tan(angle);
    final dx = slope * height;

    for (double i = x0; i - dx < size.width; i += spacing) {
      final o1 = Offset(i, y0);
      final o2 = Offset(i - dx, y1);
      canvas.drawLine(o1, o2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
