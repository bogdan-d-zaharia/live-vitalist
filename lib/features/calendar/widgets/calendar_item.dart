import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/features/aliment/data/aliment_bank.dart';
import 'package:live_vitalist/features/day/data/day_provider.dart';
import 'package:live_vitalist/features/day/domain/day_extensions.dart';
import 'package:live_vitalist/features/calendar/widgets/simple_calendar_item.dart';
import 'package:live_vitalist/features/nutrient/data/nutrient_provider.dart';
import 'package:live_vitalist/features/nutrient/domain/nutrient.dart';

class CalendarItem extends ConsumerWidget {
  const CalendarItem({
    super.key,
    required this.title,
    required this.date,
    required this.isSelected,
  });

  final String title;
  final DateTime date;
  final bool isSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dayMap = ref.watch(dayCacheProvider);
    final bank = ref.watch(alimentBankProvider);
    final nutrients = ref.watch(nutrientsProvider);

    final day = dayMap[date];
    if (day != null) {
      final intakeById = day.readIntake(bank);
      final intakeByNutrient = <Nutrient, double>{
        /* Makes sure the leading nutrient is first
           to show it specially. */
        nutrients.data[nutrients.order.first]!: 0.0,
      };

      for (final entry in intakeById.entries) {
        final nutrient = nutrients.data[entry.key];
        if (nutrient != null && !nutrient.tags.contains('disabled')) {
          intakeByNutrient[nutrient] = entry.value;
        }
      }

      return SimpleCalendarItem(
        intake: intakeByNutrient,
        title: title,
        isSelected: isSelected,
      );
    }

    ref.read(dayCacheProvider.notifier).load(date);
    return const Center(
        child: CircularProgressIndicator(strokeCap: StrokeCap.round));
  }
}
