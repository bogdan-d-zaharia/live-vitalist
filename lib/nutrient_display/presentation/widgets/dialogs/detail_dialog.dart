import 'package:flutter/material.dart';
import 'package:live_vitalist/core/presentation/widgets/mini_card.dart';
import 'package:live_vitalist/nutrient_display/domain/intake.dart';

class DetailDialog extends StatelessWidget {
  final Intake intake;
  final Map<String, double> topSources;

  const DetailDialog(
      {super.key, required this.intake, required this.topSources});

  @override
  Widget build(BuildContext context) {
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
                    Text('${intake.label} intake',
                        style: TextStyle(fontSize: 24.0)),
                    Text('Amount: '
                        '${intake.amount.toStringAsFixed(2)}'),
                    if (intake.lowerLimit != null)
                      Text('Lower Limit: '
                          '${intake.lowerLimit!.toStringAsFixed(2)}'),
                    if (intake.upperLimit != null)
                      Text('Upper Limit: '
                          '${intake.upperLimit!.toStringAsFixed(2)}'),
                    if (topSources.isNotEmpty) ...[
                      Divider(height: 24.0),
                      Text('Top Sources', style: TextStyle(fontSize: 20.0)),
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
