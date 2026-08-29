import 'package:flutter/material.dart';
import 'package:live_vitalist/core/presentation/widgets/data_input/fields_input.dart';
import 'package:live_vitalist/features/nutrient/domain/nutrient.dart';
import 'package:live_vitalist/features/nutrient_display/presentation/ui_helpers/nutrient_extensions.dart';
import 'package:live_vitalist/features/nutrient_display/presentation/widgets/dialogs/new_nutrient_dialog.dart';
import 'package:live_vitalist/features/nutrient_display/presentation/widgets/dimmed_parentheses_text.dart';
import 'package:live_vitalist/l10n/app_localizations.dart';

Future<Nutrient?> editNutrient(
  BuildContext context,
  Nutrient field,
  String nutrientKey,
) async {
  final localization = AppLocalizations.of(context);
  final localeCode = Localizations.localeOf(context).languageCode;
  final labelHint =
      localization.defaultNutrientLabel(nutrientKey) ?? nutrientKey;
  final fields = {
    'Label': field.translationOverrides[localeCode] ?? '',
    'Upper limit': field.upperLimit,
    'Lower limit': field.lowerLimit,
    'Unit': field.unit,
  };

  final isModified =
      await _pushFieldsEditor(context, fields, labelHint) ?? false;
  _setEmptyToNull(fields, 'Label');
  _setZeroToNull(fields, 'Lower limit');
  _setZeroToNull(fields, 'Upper limit');

  if (isModified) {
    final editedLabel = fields['Label'] as String?;
    final translationOverrides = {...field.translationOverrides};
    if (editedLabel == null) {
      translationOverrides.remove(localeCode);
    } else {
      translationOverrides[localeCode] = editedLabel;
    }

    return Nutrient(
      unit: fields['Unit'] as String,
      lowerLimit: fields['Lower limit'] as double?,
      upperLimit: fields['Upper limit'] as double?,
      translationOverrides: translationOverrides,
    );
  }
  return null;
}

Future<bool?> _pushFieldsEditor(
  BuildContext context,
  Map<String, dynamic> fields,
  String labelHint,
) {
  return Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: DimmedParenthesesText(
            label: labelHint,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        body: FieldsInput(
          fields: fields,
          hints: {'Label': labelHint},
        ),
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

void _setEmptyToNull(Map<String, Object?> fields, String key) {
  if (fields[key] == '') fields[key] = null;
}
