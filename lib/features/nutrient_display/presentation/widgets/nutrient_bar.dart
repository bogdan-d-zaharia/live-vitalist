import 'package:flutter/material.dart';
import 'package:live_vitalist/core/domain/interval_normalization.dart';
import 'package:live_vitalist/core/domain/intervals.dart';
import 'package:live_vitalist/core/presentation/widgets/target_bar.dart';
import 'package:live_vitalist/core/theme/palette.dart';
import 'package:live_vitalist/features/nutrient_display/domain/intake.dart';
import 'package:live_vitalist/features/nutrient_display/presentation/ui_helpers/nutrient_extensions.dart';
import 'package:live_vitalist/features/nutrient_display/presentation/nutrients_display_constants.dart';

class NutrientBar extends StatelessWidget {
  final Intake intake;
  const NutrientBar({required this.intake, super.key});

  @override
  Widget build(BuildContext context) {
    final (String? rightText, String? leftText) =
        intake.calculateRLExcessTexts(charSpacing: 3);

    final stackAddons = [
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

    return Column(
      children: [
        Row(
          children: [
            Palette.dimParentheses(
                intake.label, Theme.of(context).textTheme.bodyMedium),
            Spacer(),
            Center(
              child: Text(
                '${intake.amount.toStringAsFixed(2)} ${intake.unit}',
                style: TextStyle(letterSpacing: -0.0),
              ),
            ),
          ],
        ),
        SizedBox(height: 5.0),
        TargetBar(
          interval: LooseInterval(
            value: intake.amount,
            start: intake.lowerLimit,
            end: intake.upperLimit,
          ),
          height: height,
          radius: radius,
          stackAddons: stackAddons,
          normalizationData: NormalizationData(
            startPoint: 1.0 / 3.0,
            endPoint: 2.0 / 3.0,
            fallback: 2.0 / 3.0,
          ),
        ),
      ],
    );
  }
}
