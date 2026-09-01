import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/core/presentation/widgets/custom_card.dart';
import 'package:live_vitalist/features/aliment_bank/data/aliment_bank.dart';
import 'package:live_vitalist/features/aliment/domain/aliment.dart';
import 'package:live_vitalist/features/aliment/domain/aliment_data.dart';
import 'package:live_vitalist/features/aliment_editor/aliment_data_editor/aliment_data_editor.dart';
import 'package:live_vitalist/features/aliment_editor/aliment_data_editor/temporary_aliment_editor.dart';
import 'package:live_vitalist/features/day/data/day_provider.dart';
import 'package:live_vitalist/features/super_search/data/aliment_generator.dart';
import 'package:live_vitalist/features/super_search/domain/pending_aliment.dart';
import 'package:live_vitalist/features/super_search/presentation/controllers/super_search_controller.dart';
import 'package:live_vitalist/features/super_search/presentation/widgets/meal_picker_dialog.dart';
import 'package:live_vitalist/l10n/app_localizations.dart';

abstract final class AddAlimentActions {
  /// Creates a new aliment in the bank, so it can be instanced afterwards.
  static Future<void> addInstanced(
    BuildContext context,
    WidgetRef ref, {
    AlimentData? initialData,
  }) async {
    final AlimentData? aliment = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AlimentDataEditor(initialData: initialData ?? AlimentData.empty),
      ),
    );
    if (aliment == null) return;

    final id = aliment.hashCode.toString();
    ref.read(alimentBankProvider.notifier).setAliment(id, aliment);

    final notifier = ref.read(superSearchProvider.notifier);
    notifier.toggle(
      PendingAliment(
        alimentID: id,
        servingSize: 1.0,
        unit: aliment.unitSynonyms.isNotEmpty
            ? aliment.unitSynonyms.keys.first
            : aliment.unit,
      ),
    );
  }

  /// Creates a one-off aliment and puts it straight into a meal.
  static Future<void> addTemporary(
    BuildContext context,
    WidgetRef ref, {
    AlimentData? initialData,
  }) async {
    final TemporaryAliment newAliment = TemporaryAliment.empty;

    final newData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TemporaryAlimentEditor(
            initialData: initialData ?? newAliment.alimentData),
      ),
    );
    if (newData == null || newData.name == '') return;

    final mealName = await showMealPicker(context);
    if (mealName == null) return;

    final date = ref.read(selectedDatesProvider).first;
    ref
        .read(dayCacheProvider.notifier)
        .addAliment(date, mealName, newAliment.copyWith(alimentData: newData));
  }

  /// Asks Gemini (through Firebase AI Logic) to fill in the nutritional
  /// data for the searched text, then continues with the usual
  /// instanced/temporary flow, prefilled.
  static Future<void> addGenerated(
    BuildContext context,
    WidgetRef ref,
    String input, {
    required bool isTemp,
  }) async {
    if (input.trim() == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                AppLocalizations.of(context).superSearchWriteAlimentFirst)),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    AlimentData? generated;
    Object? error;
    try {
      generated = await AlimentGenerator.generate(input);
    } catch (e) {
      error = e;
    }
    Navigator.pop(context);

    if (generated == null) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          child: CustomCard(
            headerSpace: 0.0,
            child: Text('${error.toString()}\n'),
          ),
        ),
      );
      return;
    }

    if (isTemp) {
      await addTemporary(context, ref, initialData: generated);
    } else {
      await addInstanced(context, ref, initialData: generated);
    }
  }
}
