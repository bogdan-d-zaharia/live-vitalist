import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/features/aliment/data/aliment_data_extensions.dart';
import 'package:live_vitalist/features/aliment/domain/aliment_data.dart';
import 'package:live_vitalist/features/aliment_editor/aliment_data_editor/presentation/widgets/editor_inputs/editor_number_input.dart';
import 'package:live_vitalist/features/aliment_editor/aliment_data_editor/presentation/widgets/editor_inputs/editor_string_input.dart';
import 'package:live_vitalist/features/aliment_editor/aliment_data_editor/presentation/widgets/editor_inputs/nutrient_input.dart';
import 'package:live_vitalist/features/aliment_editor/aliment_data_editor/presentation/widgets/food_image_picker.dart';
import 'package:live_vitalist/features/nutrient/data/nutrient_provider.dart';
import 'package:live_vitalist/l10n/app_localizations.dart';

class AlimentDetailsScreen extends ConsumerWidget {
  final AlimentData data;
  final TextEditingController nameController;
  final TextEditingController unitController;
  final bool imageWasManuallySelected;
  final ValueChanged<String> onImageSelected;
  final ValueChanged<AlimentData> onDataChanged;
  final String languageCode;

  const AlimentDetailsScreen({
    required this.data,
    required this.nameController,
    required this.unitController,
    required this.imageWasManuallySelected,
    required this.onImageSelected,
    required this.onDataChanged,
    required this.languageCode,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final nutrients = ref.watch(nutrientsProvider);

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      children: [
        FoodImagePicker(
          selectedKey: data.image,
          onChanged: onImageSelected,
        ),
        EditorStringInput(
          l.alimentEditorName,
          data.readName(languageCode),
          (value) {
            final suggestedImage = imageWasManuallySelected
                ? data.image
                : suggestFoodImageForName(value)?.key;
            onDataChanged(
              data.copyWith(
                name: {
                  ...data.name,
                  languageCode: value,
                },
                image: suggestedImage,
              ),
            );
          },
          nameController,
          icon: Icons.restaurant_menu_rounded,
        ),
        EditorStringInput(
          l.alimentEditorUnit,
          data.unit,
          (value) => onDataChanged(data.copyWith(unit: value)),
          unitController,
          icon: Icons.straighten_rounded,
        ),
        EditorNumberInput(
          l.alimentEditorPerAmount,
          () => data.referenceSize,
          (value) => onDataChanged(data.copyWith(referenceSize: value)),
          unit: data.unit,
        ),
        NutrientInput('kcals', nutrients, data),
      ],
    );
  }
}
