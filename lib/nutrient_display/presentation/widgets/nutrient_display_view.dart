import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/aliment/data/aliment_bank.dart';
import 'package:live_vitalist/day/data/day_provider.dart';
import 'package:live_vitalist/day/domain/day_extensions.dart';
import 'package:live_vitalist/nutrient/data/nutrient_provider.dart';
import 'package:live_vitalist/nutrient_display/presentation/ui_helpers/nutrient_sorting_logic.dart';
import 'package:live_vitalist/nutrient_display/presentation/ui_helpers/nutrient_extensions.dart';
import 'package:live_vitalist/nutrient_display/presentation/widgets/nutrient_tile.dart';

class NutrientDisplayView extends ConsumerWidget {
  const NutrientDisplayView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avgDay = ref.watch(syncAverageDayProvider);
    final bank = ref.watch(alimentBankProvider);
    final state = ref.watch(nutrientsProvider);

    final intake = avgDay.readIntake(bank);

    final keys = filteredAndSortedKeys(state, intake);
    final widgets = keys.map((key) {
      final field = state.data[key]!;
      final value = (intake[key] ?? 0.0);
      return NutrientTile(
        intake: field.toIntake(value),
        nutrientName: key,
        bank: bank,
        day: avgDay,
      );
    }).toList();

    return Column(children: _insertDividers(widgets));
  }

  List<Widget> _insertDividers(List<Widget> widgets) {
    final divided = <Widget>[];
    for (int i = 0; i < widgets.length; i++) {
      divided.add(widgets[i]);
      if (i < widgets.length - 1) {
        divided.add(Divider(
          color: Colors.black.withValues(alpha: 0.1),
          thickness: 0.5,
          height: 0.0,
        ));
      }
    }
    return divided;
  }
}
