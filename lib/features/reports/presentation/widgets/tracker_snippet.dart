import 'package:flutter/material.dart';
import 'package:live_vitalist/l10n/app_localizations.dart';
import 'package:live_vitalist/core/domain/intervals.dart';
import 'package:live_vitalist/core/presentation/widgets/target_bar/target_bar.dart';
import 'package:live_vitalist/core/presentation/widgets/target_bar/target_bar_draw_data.dart';
import 'package:live_vitalist/core/theme/app_text_styles_theme.dart';
import 'package:live_vitalist/features/nutrient_display/domain/intake.dart';
import 'package:live_vitalist/features/reports/presentation/theme/report_styles.dart';

class TrackerSnippet extends StatelessWidget {
  final Intake? intake;
  const TrackerSnippet({super.key, required this.intake});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final rangeStyle = ReportStyles.dayViewLabel.copyWith(height: 1.0);
    final counterColor = Theme.of(context).colorScheme.onSurface;
    return Container(
      height: 80.0,
      decoration: BoxDecoration(
        color: counterColor.withValues(alpha: 0.01),
        border: Border.all(color: counterColor.withValues(alpha: 0.05)),
        borderRadius: BorderRadius.circular(16.0),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      child: intake == null
          ? Center(child: Text(l.reportsNoData,
              style: ReportStyles.dayViewBold))
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        intake!.label,
                        overflow: TextOverflow.ellipsis,
                        style: ReportStyles.dayViewBold,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      '${intake!.amount.toStringAsFixed(0)} ${intake!.unit}',
                      style: AppTextStylesTheme.of(context).dayViewRegular,
                    ),
                  ],
                ),
                TargetBar(
                  interval: LooseInterval(
                    value: intake!.amount,
                    start: intake!.lowerLimit,
                    end: intake!.upperLimit,
                  ),
                  drawData: TargetBarDrawData(
                    height: 14.0,
                    radius: 7.0,
                  ),
                ),
                Row(
                  children: [
                    if (intake!.lowerLimit != null)
                      Text(intake!.lowerLimit!.toStringAsFixed(0),
                          style: rangeStyle),
                    Spacer(),
                    if (intake!.upperLimit != null)
                      Text(intake!.upperLimit!.toStringAsFixed(0),
                          style: rangeStyle),
                  ],
                ),
              ],
            ),
    );
  }
}
