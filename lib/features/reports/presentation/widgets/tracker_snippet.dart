import 'package:flutter/material.dart';
import 'package:live_vitalist/core/domain/intervals.dart';
import 'package:live_vitalist/core/presentation/widgets/target_bar.dart';
import 'package:live_vitalist/core/theme/palette.dart';
import 'package:live_vitalist/features/nutrient_display/domain/intake.dart';

class TrackerSnippet extends StatelessWidget {
  final Intake? intake;
  const TrackerSnippet({super.key, required this.intake});

  @override
  Widget build(BuildContext context) {
    final rangeStyle = Palette.dayViewLabel.copyWith(height: 1.0);
    final counterColor = Palette.counterColor(context, flip: true);
    return Container(
      height: 80.0,
      decoration: BoxDecoration(
        color: counterColor.withValues(alpha: 0.01),
        border: Border.all(color: counterColor.withValues(alpha: 0.05)),
        borderRadius: BorderRadius.circular(16.0),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      child: intake == null
          ? Center(child: Text('No data', style: Palette.dayViewBold))
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
                        style: Palette.dayViewBold,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      '${intake!.amount.toStringAsFixed(0)} ${intake!.unit}',
                      style: Palette.dayViewRegular,
                    ),
                  ],
                ),
                TargetBar(
                  interval: LooseInterval(
                    value: intake!.amount,
                    start: intake!.lowerLimit,
                    end: intake!.upperLimit,
                  ),
                  height: 14.0,
                  radius: 7.0,
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
