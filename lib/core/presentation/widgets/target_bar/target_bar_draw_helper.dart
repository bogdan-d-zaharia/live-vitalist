import 'package:flutter/material.dart';
import 'package:live_vitalist/core/theme/palette.dart';

Color getShadowColor(BuildContext context, double shadowStrength) =>
    Palette.counterColor(context).withValues(alpha: shadowStrength);

Color getUnfilledColor(
    BuildContext context, Color color, double shadowStrength) {
  return Color.lerp(color, Palette.counterColor(context), shadowStrength)!;
}

Color getHatchedColor(
    BuildContext context, bool isFilled, Color color, double shadowStrength) {
  final barColor =
      isFilled ? color : getUnfilledColor(context, color, shadowStrength);
  return Color.lerp(barColor, Colors.green, 0.5)!;
}
