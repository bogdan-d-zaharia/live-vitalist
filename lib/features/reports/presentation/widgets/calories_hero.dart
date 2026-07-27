import 'package:flutter/material.dart';
import 'package:live_vitalist/core/domain/intervals.dart';
import 'package:live_vitalist/core/presentation/widgets/target_bar.dart';
import 'package:live_vitalist/core/theme/palette.dart';

class CaloriesHero extends StatelessWidget {
  final LooseInterval interval;
  const CaloriesHero({super.key, required this.interval});

  @override
  Widget build(BuildContext context) {
    final rangeStyle = Palette.dayViewLabel.copyWith(height: 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text('Average daily calories', style: Palette.dayViewBold),
            Spacer(),
            Text(
              '${interval.value.toStringAsFixed(0)} kcal',
              style: Palette.highlight,
            ),
          ],
        ),
        SizedBox(height: 10.0),
        TargetBar(
          interval: interval,
          height: 28.0,
          radius: 14.0,
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
