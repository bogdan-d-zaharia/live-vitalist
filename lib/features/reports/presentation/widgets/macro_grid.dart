import 'package:flutter/material.dart';
import 'package:live_vitalist/features/nutrient_display/domain/intake.dart';
import 'package:live_vitalist/features/reports/presentation/widgets/tracker_snippet.dart';

class MacroGrid extends StatelessWidget {
  final List<Intake> intakes;
  const MacroGrid({super.key, required this.intakes});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 98.0,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
      ),
      itemCount: intakes.length,
      itemBuilder: (context, index) => TrackerSnippet(intake: intakes[index]),
    );
  }
}
