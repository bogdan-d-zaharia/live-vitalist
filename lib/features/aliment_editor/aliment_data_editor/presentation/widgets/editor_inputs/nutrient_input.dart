import 'package:flutter/material.dart';
import 'package:live_vitalist/features/aliment/domain/aliment_data.dart';
import 'package:live_vitalist/features/aliment_editor/aliment_data_editor/presentation/widgets/editor_inputs/editor_number_input.dart';
import 'package:live_vitalist/features/nutrient/data/nutrient_provider.dart';
import 'package:live_vitalist/features/nutrient_display/presentation/ui_helpers/nutrient_extensions.dart';
import 'package:live_vitalist/l10n/app_localizations.dart';

class NutrientInput extends StatelessWidget {
  final String nutrientName;
  final NutrientState nutrients;
  final AlimentData data;

  const NutrientInput(
    this.nutrientName,
    this.nutrients,
    this.data, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model = nutrients.data[nutrientName];
    if (model == null) return SizedBox();

    final label = model.resolveNutrientLabel(
      localization: AppLocalizations.of(context),
      nutrientKey: nutrientName,
      localeCode: Localizations.localeOf(context).languageCode,
    );
    final unit = model.unit;

    return EditorNumberInput(
      label,
      () => data.referenceFields[nutrientName] ?? 0.0,
      (val) => data.referenceFields[nutrientName] = val,
      unit: unit,
    );
  }
}
