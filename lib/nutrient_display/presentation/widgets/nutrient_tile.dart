import 'package:flutter/material.dart';
import 'package:live_vitalist/aliment/data/aliment_bank.dart';
import 'package:live_vitalist/day/domain/day.dart';
import 'package:live_vitalist/day/domain/day_extensions.dart';
import 'package:live_vitalist/nutrient_display/domain/intake.dart';
import 'package:live_vitalist/nutrient_display/presentation/widgets/dialogs/detail_dialog.dart';
import 'package:live_vitalist/nutrient_display/presentation/widgets/nutrient_bar.dart';

class NutrientTile extends StatelessWidget {
  final Intake intake;
  final String nutrientName;
  final AlimentBankState bank;
  final Day day;

  const NutrientTile({
    super.key,
    required this.intake,
    required this.nutrientName,
    required this.bank,
    required this.day,
  });

  @override
  Widget build(BuildContext context) {
    final topAliments = day.topIntakeAliments(nutrientName, bank);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8.0),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () => showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) {
              return DetailDialog(
                intake: intake,
                topSources: topAliments.map((key, value) =>
                    MapEntry(key.readDataRef(bank).name, value)),
              );
            },
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
            child: NutrientBar(intake: intake),
          ),
        ),
      ),
    );
  }
}
