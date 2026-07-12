import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:live_vitalist/aliment/aliment.dart';
import 'package:live_vitalist/aliment/aliment_bank.dart';
import 'package:live_vitalist/aliment/aliment_data.dart';
import 'package:live_vitalist/aliment_editor/aliment_data_editor.dart';
import 'package:live_vitalist/day/day.dart';
import 'package:live_vitalist/day/day_provider.dart';
import 'package:live_vitalist/super_search/presentation/widgets/meal_picker_dialog.dart';

abstract final class AddAlimentActions {
  /// Creates a new aliment in the bank, so it can be instanced afterwards.
  static Future<void> addInstanced(BuildContext context, WidgetRef ref) async {
    final AlimentData? aliment = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const AlimentDataEditor(initialData: AlimentData.empty),
      ),
    );
    if (aliment == null) return;

    final id = aliment.hashCode.toString();
    ref.read(alimentBankProvider.notifier).setAliment(id, aliment);
  }

  /// Creates a one-off aliment and puts it straight into a meal.
  static Future<void> addTemporary(BuildContext context, WidgetRef ref) async {
    final TemporaryAliment newAliment = TemporaryAliment.empty;

    final newData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AlimentDataEditor(initialData: newAliment.alimentData),
      ),
    );
    if (newData == null || newData.name == '') return;

    final mealName = await showMealPicker(context);
    if (mealName == null) return;

    final date = ref.read(selectedDatesProvider).first;
    final day = ref.read(cachedSelectedDaysProvider).firstOrNull ?? Day();
    final meal = day.meals.firstWhere((m) => m.name == mealName);

    meal.aliments.add(newAliment.copyWith(alimentData: newData));
    ref.read(dayCacheProvider.notifier).save(date, day);
  }
}
