import 'package:flutter/material.dart';
import 'package:live_vitalist/core/presentation/widgets/data_input/fields_input.dart';
import 'package:live_vitalist/core/theme/palette.dart';
import 'package:live_vitalist/features/nutrient/domain/nutrient.dart';
import 'package:live_vitalist/features/nutrient_display/presentation/widgets/dialogs/new_nutrient_dialog.dart';
import 'package:live_vitalist/features/settings/data/settings_data.dart';

Future<Nutrient?> editNutrient(
  BuildContext context,
  Nutrient field,
) async {
  final fields = {
    'Label': field.translations[SettingsData.language]!,
    'Upper limit': field.upperLimit,
    'Lower limit': field.lowerLimit,
    'Unit': field.unit,
  };

  final isModified = await _pushFieldsEditor(context, fields) ?? false;
  _setZeroToNull(fields, 'Lower limit');
  _setZeroToNull(fields, 'Upper limit');

  if (isModified) {
    return Nutrient(
      unit: fields['Unit'] as String,
      lowerLimit: fields['Lower limit'] as double?,
      upperLimit: fields['Upper limit'] as double?,
      translations: {
        ...field.translations,
        SettingsData.language: fields['Label'] as String,
      },
    );
  }
  return null;
}

Future<bool?> _pushFieldsEditor(
    BuildContext context, Map<String, dynamic> fields) {
  return Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
            title: Palette.dimParentheses(
                fields['Label'], Theme.of(context).textTheme.headlineSmall)),
        body: FieldsInput(fields: fields),
      ),
    ),
  );
}

void showNewNutrientDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => NewNutrientDialog(),
  );
}

void _setZeroToNull(Map<String, Object?> fields, String key) {
  if (fields[key] is double && fields[key] == 0.0) fields[key] = null;
}
