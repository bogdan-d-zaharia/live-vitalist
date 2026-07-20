import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/aliment/data/aliment_bank.dart';
import 'package:live_vitalist/calorie_distribution/presentation/widgets/calorie_distribution_bar.dart';
import 'package:live_vitalist/core/presentation/widgets/custom_card.dart';
import 'package:live_vitalist/day/data/day_provider.dart';
import 'package:live_vitalist/day/domain/day_extensions.dart';

class CalorieDistributionCard extends ConsumerWidget {
  const CalorieDistributionCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bank = ref.watch(alimentBankProvider);
    final intake = ref.watch(syncAverageDayProvider).readIntake(bank);

    final carbsCalories = (intake['carbs'] ?? 0.0) * 4.0;
    final proteinCalories = (intake['protein'] ?? 0.0) * 4.0;
    final fatsCalories = (intake['fats'] ?? 0.0) * 9.0;
    final total = carbsCalories + proteinCalories + fatsCalories;

    double percent(double calories) =>
        total == 0.0 ? 0.0 : calories / total * 100.0;

    return CustomCard(
      child: CalorieDistributionBar(
        carbsPercent: percent(carbsCalories),
        proteinPercent: percent(proteinCalories),
        fatsPercent: percent(fatsCalories),
      ),
    );
  }
}
