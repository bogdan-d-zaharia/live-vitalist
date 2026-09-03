import 'package:flutter/material.dart';
import 'package:live_vitalist/core/presentation/widgets/custom_card.dart';
import 'package:live_vitalist/features/aliment/domain/aliment.dart';
import 'package:live_vitalist/features/aliment/domain/aliment_data.dart';
import 'package:live_vitalist/features/aliment_bank/data/aliment_bank.dart';
import 'package:live_vitalist/features/aliment_editor/aliment_data_editor/aliment_data_editor.dart';
import 'package:live_vitalist/features/aliment_editor/aliment_data_editor/temporary_aliment_editor.dart';
import 'package:live_vitalist/features/day/data/day_provider.dart';
import 'package:live_vitalist/features/super_search/data/aliment_generator.dart';
import 'package:live_vitalist/features/super_search/domain/pending_aliment.dart';
import 'package:live_vitalist/features/super_search/presentation/controllers/super_search_controller.dart';
import 'package:live_vitalist/features/super_search/presentation/widgets/meal_picker_dialog.dart';
import 'package:live_vitalist/l10n/app_localizations.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'add_aliment_controller.g.dart';

class AddAlimentState {
  final bool isTemp;
  final bool isGen;

  const AddAlimentState({
    this.isTemp = false,
    this.isGen = false,
  });

  AddAlimentState copyWith({
    bool? isTemp,
    bool? isGen,
  }) {
    return AddAlimentState(
      isTemp: isTemp ?? this.isTemp,
      isGen: isGen ?? this.isGen,
    );
  }
}

@riverpod
class AddAliment extends _$AddAliment {
  @override
  AddAlimentState build() => const AddAlimentState();

  void toggleTemp() => state = state.copyWith(isTemp: !state.isTemp);

  void toggleGen() => state = state.copyWith(isGen: !state.isGen);

  Future<void> add(BuildContext context, String input) {
    if (state.isGen) {
      return addGenerated(context, input, isTemp: state.isTemp);
    } else if (state.isTemp) {
      return addTemporary(context);
    } else {
      return addInstanced(context);
    }
  }

  /// Creates a new aliment in the bank, so it can be instanced afterwards.
  Future<void> addInstanced(
    BuildContext context, {
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
    ref.read(customAlimentsProvider.notifier).setAliment(id, aliment);

    ref.read(superSearchProvider.notifier).toggle(
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
  Future<void> addTemporary(
    BuildContext context, {
    AlimentData? initialData,
  }) async {
    final TemporaryAliment newAliment = TemporaryAliment.empty;

    final newData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TemporaryAlimentEditor(
          initialData: initialData ?? newAliment.alimentData,
        ),
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
  Future<void> addGenerated(
    BuildContext context,
    String input, {
    required bool isTemp,
  }) async {
    if (input.trim() == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).superSearchWriteAlimentFirst,
          ),
        ),
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
    if (!context.mounted) return;
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
      await addTemporary(context, initialData: generated);
    } else {
      await addInstanced(context, initialData: generated);
    }
  }
}
