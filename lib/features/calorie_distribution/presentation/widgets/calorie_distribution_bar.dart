import 'package:flutter/material.dart';
import 'package:live_vitalist/core/theme/palette.dart';
import 'package:live_vitalist/features/nutrient_display/presentation/nutrients_display_constants.dart';

class CalorieDistributionBar extends StatelessWidget {
  const CalorieDistributionBar({
    required this.carbsPercent,
    required this.proteinPercent,
    required this.fatsPercent,
    super.key,
  });

  final double carbsPercent;
  final double proteinPercent;
  final double fatsPercent;

  Widget label(String value) {
    return Text(
      value,
      style: Palette.dayViewRegular.copyWith(
        fontSize: fontSize,
        color: Colors.black.withValues(alpha: 0.6),
      ),
    );
  }

  Widget bar(BuildContext context) {
    const spacing = '   ';
    const widthFactor = 1.0 / 3.0;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: Colors.lightGreen,
      ),
      clipBehavior: Clip.antiAlias,
      height: height,
      child: Stack(
        alignment: Alignment.topLeft,
        fit: StackFit.expand,
        children: [
          FractionallySizedBox(
            alignment: Alignment(0.0, -1.0),
            widthFactor: widthFactor,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Center(
                child: label('Protein ${proteinPercent.toStringAsFixed(0)}%'),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: label('${spacing}Carbs ${carbsPercent.toStringAsFixed(0)}%'),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: label('Fats ${fatsPercent.toStringAsFixed(0)}%$spacing'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Calorie Distribution',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        SizedBox(height: 5.0),
        bar(context),
      ],
    );
  }
}
