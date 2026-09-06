import 'package:flutter/material.dart';
import 'package:live_vitalist/core/domain/interval_normalization.dart';
import 'package:live_vitalist/core/domain/intervals.dart';
import 'package:live_vitalist/core/presentation/widgets/hatched_pill.dart';
import 'package:live_vitalist/core/presentation/widgets/target_bar/target_bar.dart';
import 'package:live_vitalist/core/presentation/widgets/target_bar/target_bar_draw_data.dart';
import 'package:live_vitalist/features/nutrient_display/domain/intake.dart';
import 'package:live_vitalist/features/nutrient_display/presentation/nutrients_display_constants.dart';
import 'package:live_vitalist/features/nutrient_display/presentation/widgets/dimmed_parentheses_text.dart';
import 'package:live_vitalist/features/settings/data/settings_data.dart';
import 'package:live_vitalist/l10n/app_localizations.dart';

extension NumFormatting on num {
  String take(int digits) {
    double pow10 = 10;
    for (int i = 0; i < digits; i++) {
      if (this < pow10) return toStringAsFixed(digits - i - 1);
      pow10 *= 10;
    }
    return toStringAsFixed(0);
  }
}

class NutrientBar extends StatelessWidget {
  final Intake intake;
  const NutrientBar({required this.intake, super.key});

  @override
  Widget build(BuildContext context) {
    // #region // TODO: Make the calculation lazy, if SettingsData.isShowNutrientProgress
    final l = AppLocalizations.of(context);
    final leftText = switch (true) {
      _ when intake.lowerLimit != null && intake.amount < intake.lowerLimit! =>
        l.nutrientDisplayNutrientLeft(
          (intake.lowerLimit! - intake.amount).take(3),
          intake.unit,
        ),
      _ when intake.upperLimit != null && intake.amount < intake.upperLimit! =>
        l.nutrientDisplayNutrientRemaining(
          (intake.upperLimit! - intake.amount).take(3),
          intake.unit,
        ),
      _ when intake.upperLimit != null && intake.amount > intake.upperLimit! =>
        l.nutrientDisplayNutrientOver(
          (intake.amount - intake.upperLimit!).take(3),
          intake.unit,
        ),
      _ => l.nutrientDisplayGoalReached,
    };
    final percentage = switch (true) {
      _ when intake.lowerLimit != null && intake.amount < intake.lowerLimit! =>
        intake.amount / intake.lowerLimit!,
      _ when intake.upperLimit != null && intake.amount > intake.upperLimit! =>
        intake.amount / intake.upperLimit!,
      _ => 1.0,
    };
    final rightText = '${(percentage * 100.0).toInt()}%';
    // #endregion

    final outOf = switch (true) {
      _ when intake.lowerLimit != null && intake.amount < intake.lowerLimit! =>
        ' / ${intake.lowerLimit!.take(3)}',
      _ when intake.upperLimit != null => ' / ${intake.upperLimit!.take(3)}',
      _ when intake.lowerLimit != null => ' / ${intake.lowerLimit!.take(3)}',
      _ => '',
    };
    final amountText = '${intake.amount.take(3)}'
        '$outOf ${intake.unit}';

    final style = Theme.of(context).textTheme.bodyMedium;
    final dim = style != null ? dimStyle(style) : null;
    final amountStyle = TextStyle(letterSpacing: -0.0);

    return Column(
      children: [
        Row(
          children: [
            DimmedParenthesesText(label: intake.label, style: style),
            Spacer(),
            Center(child: Text(amountText, style: amountStyle)),
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
            pill: HatchedPill(),
            isPillForeground: true,
          ),
          normalizationData: NormalizationData.thirds,
        ),
        if (SettingsData.isShowNutrientProgress)
          Row(
            children: [
              Text(leftText, style: dim),
              Spacer(),
              Text(rightText, style: dim),
            ],
          ),
      ],
    );
  }
}
