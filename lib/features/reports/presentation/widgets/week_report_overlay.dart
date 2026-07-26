import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/core/domain/intervals.dart';
import 'package:live_vitalist/core/presentation/widgets/custom_card.dart';
import 'package:live_vitalist/core/theme/palette.dart';
import 'package:live_vitalist/features/nutrient/data/nutrient_provider.dart';
import 'package:live_vitalist/features/nutrient_display/domain/intake.dart';
import 'package:live_vitalist/features/reports/domain/entities/week_report.dart';
import 'package:live_vitalist/features/reports/presentation/widgets/calories_hero.dart';
import 'package:live_vitalist/features/reports/presentation/widgets/consistency_strip.dart';
import 'package:live_vitalist/features/reports/presentation/widgets/macro_grid.dart';

class WeekReportOverlay extends ConsumerWidget {
  final WeekReport wr;
  const WeekReportOverlay({super.key, required this.wr});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nutrients = ref.watch(nutrientsProvider).data;
    final intakes = wr.averageIntake.map(
      (key, value) => MapEntry(
        key,
        Intake(
          nutrients[key]?.translations['ENG'] ?? '',
          value,
          nutrients[key]?.lowerLimit,
          nutrients[key]?.upperLimit,
          nutrients[key]?.unit ?? '',
        ),
      ),
    );
    final averageCalories = intakes.remove('kcals');
    final macros = intakes.values.toList(); // the remaining
    final maxHeight = MediaQuery.sizeOf(context).height * 0.9;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 420.0, maxHeight: maxHeight),
        child: SingleChildScrollView(
          child: CustomCard(
            padding: EdgeInsets.symmetric(
              vertical: 22.0,
              horizontal: 20.0,
            ),
            headerSpace: 0.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      color: Palette.selectGreen,
                      size: 26.0,
                    ),
                    SizedBox(width: 12.0),
                    Expanded(
                      child: Text(
                        'Week ${wr.number} Report',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontSize: 28.0),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.0),
                Text('Jul 14 - Jul 20', style: Palette.monitor),
                SizedBox(height: 20.0),
                if (averageCalories != null) ...[
                  CaloriesHero(
                    interval: LooseInterval(
                      value: averageCalories.amount,
                      start: averageCalories.lowerLimit,
                      end: averageCalories.upperLimit,
                    ),
                  ),
                  SizedBox(height: 22.0)
                ],
                ConsistencyStrip(days: wr.completedDays),
                SizedBox(height: 22.0),
                MacroGrid(intakes: macros),
                if (wr.tips.isNotEmpty) ...[
                  SizedBox(height: 18.0),
                  Divider(color: Palette.divGrey, height: 1.0),
                  ...wr.tips.expand(
                    (tip) => [
                      SizedBox(height: 14.0),
                      Text(tip, style: Palette.monitor),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
