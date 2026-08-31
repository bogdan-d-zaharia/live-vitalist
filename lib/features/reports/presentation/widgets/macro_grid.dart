import 'package:flutter/material.dart';
import 'package:live_vitalist/l10n/app_localizations.dart';
import 'package:live_vitalist/features/reports/presentation/theme/report_styles.dart';
import 'package:live_vitalist/features/reports/domain/entities/intake_evolution.dart';
import 'package:live_vitalist/features/reports/presentation/widgets/intake_evolution_row.dart';

class MacroGrid extends StatelessWidget {
  final List<IntakeEvolution> evolutions;
  const MacroGrid({super.key, required this.evolutions});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(l.reportsPreviousWeek,
                  style: ReportStyles.dayViewBold),
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: Text(l.reportsCurrentWeek,
                  style: ReportStyles.dayViewBold),
            ),
          ],
        ),
        SizedBox(height: 14.0),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: evolutions.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10.0),
            itemBuilder: (context, index) =>
                IntakeEvolutionRow(intakeEvolution: evolutions[index]),
          ),
        ),
      ],
    );
  }
}
