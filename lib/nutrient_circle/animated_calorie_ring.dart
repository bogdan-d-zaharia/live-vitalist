import 'package:flutter/material.dart';
import 'package:live_vitalist/nutrient_circle/pie_chart.dart';

class AnimatedCalorieRing extends StatelessWidget {
  const AnimatedCalorieRing({
    required this.targetPercentage,
    required this.targetStrokeWidth,
    this.duration = const Duration(milliseconds: 1200),
    super.key,
  });

  final double targetPercentage;
  final double targetStrokeWidth;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: targetPercentage),
      duration: duration,
      curve: Curves.easeOutExpo,
      builder: (context, animatedPercentage, _) {
        return TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: targetStrokeWidth),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutBack,
          builder: (context, animatedStrokeWidth, _) {
            return CalorieRing(
              percentage: animatedPercentage,
              strokeWidth: animatedStrokeWidth,
            );
          },
        );
      },
    );
  }
}
