import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/core/presentation/widgets/custom_card.dart';
import 'package:live_vitalist/features/aliment/data/aliment_bank.dart';
import 'package:live_vitalist/features/day/data/day_provider.dart';
import 'package:live_vitalist/features/day/domain/day_extensions.dart';
import 'package:live_vitalist/features/nutrient/data/nutrient_provider.dart';
import 'package:live_vitalist/features/settings/data/settings_data.dart';
import 'package:live_vitalist/features/nutrient_circle/presentation/widgets/animated_calorie_ring.dart';
import 'package:live_vitalist/features/nutrient_circle/presentation/nutrient_circle_constants.dart';
import 'package:live_vitalist/core/theme/app_text_styles_theme.dart';

class NutrientCircle extends ConsumerWidget {
  const NutrientCircle({super.key});

  String _format(double value) =>
      value.toStringAsFixed(NutrientCircleConstants.numDigits);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nutrientState = ref.watch(nutrientsProvider);
    final avgDay = ref.watch(syncAverageDayProvider);
    final bank = ref.watch(alimentBankProvider);

    if (nutrientState.order.isEmpty) return const SizedBox.shrink();

    final key = nutrientState.order.firstWhere(
      (key) => !nutrientState.data[key]!.tags.contains('disabled'),
      orElse: () => nutrientState.order.first,
    );
    final nutrient = nutrientState.data[key]!;
    final label = nutrient.translations[SettingsData.language] ?? key;
    final unit = nutrient.unit;

    final amount = avgDay.readIntake(bank)[key] ?? 0.0;
    final target = nutrient.lowerLimit ?? nutrient.upperLimit;
    final percentage =
        (target == null || target == 0.0) ? 0.0 : amount / target;

    return CustomCard(
      title: label,
      logo: const Icon(Icons.pie_chart),
      child: Center(
        child: SizedBox(
          width: NutrientCircleConstants.ringSize,
          height: NutrientCircleConstants.ringSize,
          child: Stack(
            fit: StackFit.expand,
            children: [
              AnimatedCalorieRing(
                targetPercentage: percentage,
                targetStrokeWidth: NutrientCircleConstants.strokeWidth,
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${_format(amount)} $unit',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontSize: 26.0),
                    ),
                    if (target != null)
                      Text(
                        '/ ${_format(target)} $unit',
                        style: AppTextStylesTheme.of(context).dayViewRegular,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
