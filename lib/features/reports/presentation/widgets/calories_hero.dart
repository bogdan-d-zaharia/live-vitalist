import 'package:flutter/material.dart';
import 'package:live_vitalist/core/domain/intervals.dart';
import 'package:live_vitalist/core/presentation/widgets/target_bar/target_bar.dart';
import 'package:live_vitalist/core/presentation/widgets/target_bar/target_bar_draw_data.dart';
import 'package:live_vitalist/core/theme/app_text_styles_theme.dart';
import 'package:live_vitalist/features/reports/presentation/theme/report_styles.dart';

class CaloriesHero extends StatelessWidget {
  final LooseInterval interval;
  const CaloriesHero({super.key, required this.interval});

  @override
  Widget build(BuildContext context) {
    final rangeStyle = ReportStyles.dayViewLabel.copyWith(height: 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text('Average daily calories', style: ReportStyles.dayViewBold),
            Spacer(),
            Text(
              '${interval.value.toStringAsFixed(0)} kcal',
              style: AppTextStylesTheme.of(context).highlight,
            ),
          ],
        ),
        SizedBox(height: 10.0),
        TargetBar(
          interval: interval,
          drawData: TargetBarDrawData(
            height: 28.0,
            radius: 14.0,
          ),
        ),
        SizedBox(height: 6.0),
        Row(
          children: [
            if (interval.start != null)
              Text('${interval.start}', style: rangeStyle),
            Spacer(),
            if (interval.end != null)
              Text('${interval.end}', style: rangeStyle),
          ],
        ),
      ],
    );
  }
}
