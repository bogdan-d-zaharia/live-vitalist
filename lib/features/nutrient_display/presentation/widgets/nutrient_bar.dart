import 'package:flutter/material.dart';
import 'package:live_vitalist/core/theme/palette.dart';
import 'package:live_vitalist/features/nutrient_display/domain/intake.dart';
import 'package:live_vitalist/features/nutrient_display/presentation/ui_helpers/nutrient_extensions.dart';
import 'package:live_vitalist/features/nutrient_display/presentation/nutrients_display_constants.dart';

class NutrientBar extends StatelessWidget {
  const NutrientBar({required this.intake, super.key});

  final Intake intake;

  Widget bar(BuildContext context) {
    if ((intake.lowerLimit == null || intake.lowerLimit == 0.0) &&
        (intake.upperLimit == null || intake.upperLimit == 0.0)) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: Colors.grey,
        ),
        height: height,
      );
    } else {
      final double top = (intake.upperLimit ?? intake.lowerLimit!) * 1.5;
      final (String? rightText, String? leftText) =
          intake.calculateRLExcessTexts(charSpacing: 3);

      /// TODO: Make reach corners round.
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: Colors.orange,
        ),
        clipBehavior: Clip.antiAlias,
        height: height,
        child: Stack(
          alignment: Alignment.topLeft,
          fit: StackFit.expand,
          children: [
            FractionallySizedBox(
              alignment: Alignment.topLeft,
              widthFactor: (intake.upperLimit ?? top) / top,
              child: Container(color: Colors.green),
            ),
            FractionallySizedBox(
              alignment: Alignment.topLeft,
              widthFactor: (intake.lowerLimit ?? 0.0) / top,
              child: Container(color: Colors.lightGreen),
            ),
            FractionallySizedBox(
              alignment: Alignment.topRight,
              widthFactor: 1.0 - (intake.amount.clamp(0.0, top) / top),
              child: Container(
                  color: (Palette.isDarkMode(context)
                          ? Colors.black
                          : Colors.white)
                      .withValues(alpha: 0.7)),
            ),
            if (rightText != null)
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  rightText,
                  style: Palette.dayViewRegular.copyWith(
                    fontSize: fontSize,
                    color: Colors.black.withValues(alpha: 0.6),
                  ),
                ),
              ),
            if (leftText != null)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  leftText,
                  style: Palette.dayViewRegular.copyWith(
                    fontSize: fontSize,
                    color: Colors.black.withValues(alpha: 0.6),
                  ),
                ),
              ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Palette.dimParentheses(
                intake.label, Theme.of(context).textTheme.bodyMedium),
            Spacer(),
            Center(
              child: Text('${intake.amount.toStringAsFixed(2)} ${intake.unit}',
                  style: TextStyle(letterSpacing: -0.0)),
            ),
          ],
        ),
        SizedBox(height: 5.0),
        bar(context),
      ],
    );
  }
}
