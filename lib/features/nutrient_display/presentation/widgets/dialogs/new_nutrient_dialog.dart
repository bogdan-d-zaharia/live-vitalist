import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/features/nutrient/presentation/widgets/nutrient_async_status.dart';
import 'package:live_vitalist/core/presentation/widgets/data_input/string_input.dart';
import 'package:live_vitalist/features/nutrient/data/nutrient_provider.dart';
import 'package:live_vitalist/features/nutrient/domain/nutrient.dart';
import 'package:live_vitalist/l10n/app_localizations.dart';

class NewNutrientDialog extends ConsumerWidget {
  const NewNutrientDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final nutrientAsync = ref.watch(nutrientsProvider);
    if (nutrientAsync.isLoading ||
        nutrientAsync.hasError ||
        !nutrientAsync.hasValue) {
      return NutrientAsyncStatus(value: nutrientAsync);
    }
    final nutrientNotifier = ref.read(
        nutrientConfigProvider(nutrientAsync.requireValue.configId!).notifier);
    final localeCode = Localizations.localeOf(context).languageCode;
    return Dialog(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: StringInput(
          initString: l.nutrientDisplayNewNutrient,
          submit: (newKey) {
            final key = newKey.trim();
            if (key.isEmpty) return;

            final newNutrient = Nutrient(
              unit: 'g',
              lowerLimit: null,
              upperLimit: null,
              tags: [],
              translationOverrides: {localeCode: key},
            );

            nutrientNotifier.addNutrient(key, newNutrient);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
