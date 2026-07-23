import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/core/presentation/widgets/custom_card.dart';
import 'package:live_vitalist/features/nutrient/data/nutrient_provider.dart';
import 'package:live_vitalist/features/reports/domain/entities/week_report.dart';

class WeekReportOverlay extends ConsumerWidget {
  final WeekReport wr;
  const WeekReportOverlay({super.key, required this.wr});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calories = ref.watch(nutrientsProvider).data['kcals'];
    return CustomCard(
      title: 'Week ${wr.number} Report',
      logo: Icon(Icons.calendar_today_rounded),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (calories != null)
            Text(
              '${wr.averageCalories}'
              ' / '
              '${calories.upperLimit ?? calories.lowerLimit}',
            )
        ],
      ),
    );
  }
}
