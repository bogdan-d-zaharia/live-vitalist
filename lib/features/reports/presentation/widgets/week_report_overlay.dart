import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/core/domain/intervals.dart';
import 'package:live_vitalist/core/presentation/widgets/mini_card.dart';
import 'package:live_vitalist/core/theme/app_colors_theme.dart';
import 'package:live_vitalist/features/reports/presentation/theme/report_styles.dart';
import 'package:live_vitalist/features/nutrient/data/nutrient_provider.dart';
import 'package:live_vitalist/features/nutrient_display/domain/intake.dart';
import 'package:live_vitalist/features/nutrient_display/presentation/ui_helpers/nutrient_extensions.dart';
import 'package:live_vitalist/features/reports/domain/entities/intake_evolution.dart';
import 'package:live_vitalist/features/reports/domain/entities/week_report.dart';
import 'package:live_vitalist/features/reports/presentation/widgets/calories_hero.dart';
import 'package:live_vitalist/features/reports/presentation/widgets/consistency_strip.dart';
import 'package:live_vitalist/features/reports/presentation/widgets/macro_grid.dart';
import 'package:live_vitalist/l10n/app_localizations.dart';

class WeekReportOverlay extends ConsumerWidget {
  final WeekReport weekReport;
  const WeekReportOverlay({
    super.key,
    required this.weekReport,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nutrients = ref.watch(nutrientsProvider).data;
    final localization = AppLocalizations.of(context);
    final localeCode = Localizations.localeOf(context).languageCode;
    final intakes = weekReport.currentWeek.averageIntake.map(
      (key, value) {
        final nutrient = nutrients[key];
        final label = nutrient?.resolveNutrientLabel(
              localization: localization,
              nutrientKey: key,
              localeCode: localeCode,
            ) ??
            key;
        return MapEntry(
          key,
          IntakeEvolution(
            weekReport.previousWeek.averageIntake[key] != null
                ? Intake(
                    label,
                    weekReport.previousWeek.averageIntake[key]!,
                    nutrient?.lowerLimit,
                    nutrient?.upperLimit,
                    nutrient?.unit ?? '',
                  )
                : null,
            Intake(
              label,
              value,
              nutrient?.lowerLimit,
              nutrient?.upperLimit,
              nutrient?.unit ?? '',
            ),
          ),
        );
      },
    );
    final averageCalories = intakes.remove('kcals')?.current;
    final evolutions = intakes.values.toList(); // the remaining
    final maxHeight = MediaQuery.sizeOf(context).height * 0.9;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(12.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 420.0, maxHeight: maxHeight),
        child: AspectRatio(
          aspectRatio: 4 / 6,
          child: MiniCard(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 22.0,
                horizontal: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        color: AppColorsTheme.of(context).select,
                        size: 26.0,
                      ),
                      SizedBox(width: 12.0),
                      Expanded(
                        child: Text(
                          'Week ${weekReport.currentWeek.number} Report',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(fontSize: 28.0),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.0),
                  Text('Jul 14 - Jul 20', style: ReportStyles.monitor),
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
                  ConsistencyStrip(days: weekReport.currentWeek.completedDays),
                  SizedBox(height: 22.0),
                  Expanded(child: MacroGrid(evolutions: evolutions)),
                  if (weekReport.currentWeek.tips != null &&
                      weekReport.currentWeek.tips!.isNotEmpty) ...[
                    SizedBox(height: 18.0),
                    Divider(
                      color: Theme.of(context).dividerColor,
                      height: 1.0,
                    ),
                    ...weekReport.currentWeek.tips!.expand(
                      (tip) => [
                        SizedBox(height: 14.0),
                        Text(tip, style: ReportStyles.monitor),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
