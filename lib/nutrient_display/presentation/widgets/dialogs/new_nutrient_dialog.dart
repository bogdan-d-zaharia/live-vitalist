import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/core/presentation/widgets/data_input/string_input.dart';
import 'package:live_vitalist/nutrient/data/nutrient_provider.dart';
import 'package:live_vitalist/nutrient/domain/nutrient.dart';
import 'package:live_vitalist/settings/data/settings_data.dart';

class NewNutrientDialog extends ConsumerWidget {
  const NewNutrientDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nutrientNotifier = ref.read(nutrientsProvider.notifier);
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Expanded(
          child: StringInput(
            initString: 'new_nutrient_key',
            submit: (newKey) {
              final key = newKey.trim();
              if (key.isEmpty) return;

              final newNutrient = Nutrient(
                unit: 'g',
                lowerLimit: null,
                upperLimit: null,
                tags: [],
                translations: {SettingsData.language: key},
              );

              nutrientNotifier.addNutrient(key, newNutrient);
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }
}
