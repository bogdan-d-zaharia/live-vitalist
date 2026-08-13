import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/features/aliment/domain/aliment_data.dart';
import 'package:live_vitalist/features/aliment_editor/aliment_data_editor/presentation/widgets/editor_inputs/editor_number_input.dart';
import 'package:live_vitalist/features/aliment_editor/aliment_data_editor/presentation/widgets/editor_inputs/editor_string_input.dart';
import 'package:live_vitalist/features/aliment_editor/aliment_data_editor/presentation/widgets/editor_inputs/nutrient_input.dart';
import 'package:live_vitalist/features/nutrient/data/nutrient_provider.dart';

class AlimentDetailsScreen extends ConsumerWidget {
  final AlimentData data;
  final TextEditingController nameController;
  final TextEditingController unitController;
  final ValueChanged<AlimentData> onDataChanged;

  const AlimentDetailsScreen({
    required this.data,
    required this.nameController,
    required this.unitController,
    required this.onDataChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nutrients = ref.watch(nutrientsProvider);

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      children: [
        EditorStringInput(
          'Name',
          data.name,
          (value) => onDataChanged(data.copyWith(name: value)),
          nameController,
        ),
        EditorStringInput(
          'Unit',
          data.unit,
          (value) => onDataChanged(data.copyWith(unit: value)),
          unitController,
        ),
        EditorNumberInput(
          'Per amount',
          () => data.referenceSize,
          (value) => onDataChanged(data.copyWith(referenceSize: value)),
          unit: data.unit,
        ),
        NutrientInput('kcals', nutrients, data),
      ],
    );
  }
}
