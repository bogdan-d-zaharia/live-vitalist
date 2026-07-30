import 'package:flutter/material.dart';
import 'package:live_vitalist/features/reports/domain/entities/intake_evolution.dart';
import 'package:live_vitalist/features/reports/presentation/widgets/tracker_snippet.dart';

class IntakeEvolutionRow extends StatelessWidget {
  final IntakeEvolution intakeEvolution;
  const IntakeEvolutionRow({super.key, required this.intakeEvolution});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: TrackerSnippet(intake: intakeEvolution.previous)),
        SizedBox(width: 10.0),
        Expanded(child: TrackerSnippet(intake: intakeEvolution.current)),
      ],
    );
  }
}
