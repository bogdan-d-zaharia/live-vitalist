import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/aliment/domain/aliment_data.dart';
import 'package:live_vitalist/aliment_editor/aliment_data_editor/presentation/aliment_data_editor_constants.dart';
import 'package:live_vitalist/aliment_editor/aliment_data_editor/presentation/widgets/editor_inputs/editor_number_input.dart';
import 'package:live_vitalist/aliment_editor/aliment_data_editor/presentation/widgets/editor_inputs/editor_string_input.dart';
import 'package:live_vitalist/aliment_editor/aliment_data_editor/presentation/widgets/editor_inputs/nutrient_input.dart';
import 'package:live_vitalist/aliment_editor/aliment_data_editor/presentation/widgets/unit_synonyms_editor.dart';
import 'package:live_vitalist/nutrient/data/nutrient_provider.dart';

class AlimentDataForm extends ConsumerStatefulWidget {
  final AlimentData data;
  final TextEditingController nameController;
  final TextEditingController unitController;
  final Function(AlimentData) onDataChanged;
  final Function() onSave;

  const AlimentDataForm({
    required this.data,
    required this.nameController,
    required this.unitController,
    required this.onDataChanged,
    required this.onSave,
    super.key,
  });

  @override
  ConsumerState<AlimentDataForm> createState() => _AlimentDataFormState();
}

class _AlimentDataFormState extends ConsumerState<AlimentDataForm> {
  bool isShowAdvanced = false;

  NutrientState get nutrients => ref.watch(nutrientsProvider);
  AlimentData get data => widget.data;

  Widget _nutrientInput(String key) => NutrientInput(key, nutrients, data);

  @override
  Widget build(BuildContext context) {
    final advancedFields = nutrients.order
        .where((k) =>
            !basicFields.contains(k) &&
            !nutrients.data[k]!.tags.contains('disabled'))
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ListView(
        children: [
          EditorStringInput(
            'Name',
            data.name,
            (val) => widget.onDataChanged(data.copyWith(name: val)),
            widget.nameController,
          ),
          EditorStringInput(
            'Unit',
            data.unit,
            (val) => widget.onDataChanged(data.copyWith(unit: val)),
            widget.unitController,
          ),
          EditorNumberInput(
            'Per amount',
            () => data.referenceSize,
            (val) => widget.onDataChanged(data.copyWith(referenceSize: val)),
            unit: data.unit,
          ),
          ...basicFields.map(_nutrientInput),
          Row(
            children: [
              const Text('Show advanced'),
              const Spacer(),
              Switch(
                value: isShowAdvanced,
                onChanged: (v) => setState(() => isShowAdvanced = v),
              ),
            ],
          ),
          if (isShowAdvanced) ...[
            ...advancedFields.map(_nutrientInput),
            const SizedBox(height: 12),
            const Text('Unit synonyms:'),
            UnitSynonymsEditor(
              synonyms: data.unitSynonyms,
              onChanged: (m) =>
                  widget.onDataChanged(data.copyWith(unitSynonyms: m)),
            ),
          ],
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: widget.onSave,
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
