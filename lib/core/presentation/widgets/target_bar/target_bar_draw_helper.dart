import 'package:flutter/material.dart';

Color getShadowColor(BuildContext context, double shadowStrength) =>
    Theme.of(context).colorScheme.surface.withValues(alpha: shadowStrength);

Color getUnfilledColor(
    BuildContext context, Color color, double shadowStrength) {
  return Color.lerp(
      color, Theme.of(context).colorScheme.surface, shadowStrength)!;
}

Color getHatchedColor(
    BuildContext context, bool isFilled, Color color, double shadowStrength) {
  final barColor =
      isFilled ? color : getUnfilledColor(context, color, shadowStrength);
  return Color.lerp(barColor, Colors.green, 0.5)!;
}
