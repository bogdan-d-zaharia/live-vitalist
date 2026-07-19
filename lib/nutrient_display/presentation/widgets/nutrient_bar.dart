import 'package:flutter/material.dart';
import 'package:live_vitalist/core/theme/palette.dart';
import 'package:live_vitalist/nutrient_display/domain/intake.dart';
import 'package:live_vitalist/nutrient_display/presentation/ui_helpers/nutrient_extensions.dart';
import 'package:live_vitalist/nutrient_display/presentation/nutrients_display_constants.dart';

class NutrientBar extends StatelessWidget {
  const NutrientBar({required this.intake, super.key});

  final Intake intake;

  Widget bar(BuildContext context) {
    final (String? rightText, String? leftText) =
        intake.calculateRLExcessTexts(charSpacing: 3);

    final texts = [
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
    ];

    final count = (intake.lowerLimit != null ? 1 : 0) +
        (intake.upperLimit != null ? 1 : 0);
    final widthFactor = 1.0 / (count + 1);

    double getFactor(double a, double w, double? l, double? u) {
      late double result;
      if (l != null && u != null) {
        if (a <= l) {
          result = a / l * w;
        } else if (a <= u) {
          result = (1.0 + (a - l) / (u - l)) * w;
        } else {
          result = (2.0 + (a - u) / l) * w;
        }
      } else if (l != null && u == null) {
        result = a / l * w;
      } else if (l == null && u != null) {
        result = a / u * w;
      } else {
        result = 1.0;
      }

      return result.clamp(0.0, 1.0);
    }

    final factor = getFactor(
        intake.amount, widthFactor, intake.lowerLimit, intake.upperLimit);

    double getAlignment() {
      if (count == 2 || count == 0) {
        return 0.0;
      } else if (intake.lowerLimit == null) {
        return -1.0;
      } else {
        return 1.0;
      }
    }

    final alignment = getAlignment();

    /// TODO: Make reach corners round.
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: Colors.lightGreen,
        // color: Color.lerp(
        //   Colors.lightGreen,
        //   Palette.isDarkMode(context) ? Colors.black : Colors.white,
        //   0.7,
        // )!,
      ),
      clipBehavior: Clip.antiAlias,
      height: height,
      child: Stack(
        alignment: Alignment.topLeft,
        fit: StackFit.expand,
        children: [
          FractionallySizedBox(
            alignment: Alignment(alignment, -1.0),
            widthFactor: widthFactor,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(20.0),
                // boxShadow: [
                //   BoxShadow(
                //     // blurRadius: 6.0,
                //     // spreadRadius: 1.9,
                //     color: Colors.lightGreen.shade300.withValues(alpha: 0.5),
                //     blurStyle: BlurStyle.outer,
                //   )
                // ],
              ),
            ),
          ),
          // FractionallySizedBox(
          //   alignment: Alignment.topLeft,
          //   widthFactor: factor,
          //   child: Container(
          //     decoration: BoxDecoration(
          //       color: Colors.lightGreen,
          //       // borderRadius: BorderRadius.circular(20.0),
          //     ),
          //   ),
          // ),
          FractionallySizedBox(
            alignment: Alignment.topRight,
            widthFactor: 1.0 - factor,
            child: Container(
                color:
                    (Palette.isDarkMode(context) ? Colors.black : Colors.white)
                        .withValues(alpha: 0.7)),
          ),
          ...texts,
        ],
      ),
    );
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
