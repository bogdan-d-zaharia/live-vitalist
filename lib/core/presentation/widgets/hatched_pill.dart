import 'dart:math';

import 'package:flutter/material.dart';
import 'package:live_vitalist/core/presentation/widgets/hatching_painter.dart';

class HatchedPill extends StatelessWidget {
  final Color color;
  final double pillRadius;
  final double? hatchingRingRadius;
  final double hatchingRingWidth;

  const HatchedPill({
    super.key,
    this.color = Colors.green,
    this.pillRadius = 4.0,
    this.hatchingRingRadius = 2.0,
    this.hatchingRingWidth = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(pillRadius),
      ),
      child: CustomPaint(
        painter: HatchingPainter(
          color: color,
          dHeight: 4.0,
          spacing: 5.0,
          width: 1.5,
          angle: pi / 4,
        ),
      ),
    );
  }
}
