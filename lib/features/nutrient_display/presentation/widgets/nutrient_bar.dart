import 'package:flutter/material.dart';
import 'package:live_vitalist/core/domain/interval_normalization.dart';
import 'package:live_vitalist/core/domain/intervals.dart';
import 'package:live_vitalist/core/presentation/widgets/hatched_pill.dart';
import 'package:live_vitalist/core/presentation/widgets/target_bar/target_bar.dart';
import 'package:live_vitalist/core/presentation/widgets/target_bar/target_bar_draw_data.dart';
import 'package:live_vitalist/core/presentation/widgets/target_bar/target_bar_draw_helper.dart';
import 'package:live_vitalist/core/theme/palette.dart';
import 'package:live_vitalist/features/nutrient_display/domain/intake.dart';
import 'package:live_vitalist/features/nutrient_display/presentation/ui_helpers/nutrient_extensions.dart';
import 'package:live_vitalist/features/nutrient_display/presentation/nutrients_display_constants.dart';
import 'package:live_vitalist/features/nutrient_display/presentation/widgets/addon_text.dart';

class NutrientBar extends StatelessWidget {
  final Intake intake;
  const NutrientBar({required this.intake, super.key});

  @override
  Widget build(BuildContext context) {
    final (String? rightText, String? leftText) =
        intake.calculateRLExcessTexts(charSpacing: 3);
    final normalizationData = NormalizationData.thirds;
    final looseInterval = LooseInterval(
      value: intake.amount,
      start: intake.lowerLimit,
      end: intake.upperLimit,
    );
    final u = looseInterval.normalize(normalizationData);

    final Color? leftEmphasis = u.start <= 0.1
        ? getHatchedColor(context, u.value >= 0.1, Colors.lightGreen, 0.7)
        : null;
    final Color? rightEmphasis = u.end >= 0.9
        ? getHatchedColor(context, u.value >= 0.9, Colors.lightGreen, 0.7)
        : null;

    final stackAddons = [
      if (rightText != null)
        Align(
          alignment: Alignment.centerRight,
          child: AddonText(text: rightText, emphasisColor: rightEmphasis),
        ),
      if (leftText != null)
        Align(
          alignment: Alignment.centerLeft,
          child: AddonText(text: leftText, emphasisColor: leftEmphasis),
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
          drawData: TargetBarDrawData(
            height: height,
            radius: radius,
            stackAddons: stackAddons,
            pill: HatchedPill(),
            isPillForeground: true,
          ),
          normalizationData: NormalizationData.thirds,
        ),
      ],
    );
  }
}
