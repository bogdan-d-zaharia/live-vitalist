import 'dart:math';

import 'package:flutter/material.dart';

class FadeInOutCurve extends Curve {
  final double start;
  final double end;
  final double peakPosition;
  final double ascent;
  final double descent;

  const FadeInOutCurve({
    this.start = 0.05,
    this.end = 0.95,
    this.peakPosition = 0.5,
    this.ascent = 8.0,
    this.descent = 8.0,
  });

  @override
  double transformInternal(double t) {
    if (t <= start || t >= end) return 0.0;

    if (t <= peakPosition) {
      final double u = (t - start) / (peakPosition - start);
      return 1.0 - pow(1.0 - u, ascent).toDouble();
    } else {
      final double v = (t - peakPosition) / (end - peakPosition);
      return 1.0 - pow(v, descent).toDouble();
    }
  }
}
