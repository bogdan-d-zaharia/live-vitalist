import 'package:flutter/material.dart';
import 'package:live_vitalist/core/presentation/widgets/mini_card.dart';
import 'package:live_vitalist/features/nutrient_display/domain/intake.dart';
import 'package:live_vitalist/l10n/app_localizations.dart';

class DetailDialog extends StatelessWidget {
  final Intake intake;
  final Map<String, double> topSources;

  const DetailDialog(
      {super.key, required this.intake, required this.topSources});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final amount = intake.amount.toStringAsFixed(2);
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: MiniCard(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.0),
                    Text(l.nutrientDisplayIntake(intake.label),
                        style: TextStyle(fontSize: 24.0)),
                    Text(l.nutrientDisplayAmountValue(amount)),
                    if (intake.lowerLimit != null)
                      Text(l.nutrientDisplayLowerLimitValue(
                          intake.lowerLimit!.toStringAsFixed(2))),
                    if (intake.upperLimit != null)
                      Text(l.nutrientDisplayUpperLimitValue(
                          intake.upperLimit!.toStringAsFixed(2))),
                    if (topSources.isNotEmpty) ...[
                      Divider(height: 24.0),
                      Text(l.nutrientDisplayTopSources,
                          style: TextStyle(fontSize: 20.0)),
                      for (final entry in topSources.entries)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            '${entry.key}: '
                            '${entry.value.toStringAsFixed(2)}',
                          ),
                        ),
                    ],
                    SizedBox(height: 24.0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
