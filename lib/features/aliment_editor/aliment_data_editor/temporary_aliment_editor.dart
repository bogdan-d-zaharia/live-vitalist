import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/features/aliment/domain/aliment_data.dart';
import 'package:live_vitalist/features/aliment_editor/aliment_data_editor/presentation/widgets/editor_inputs/editor_string_input.dart';
import 'package:live_vitalist/features/aliment_editor/aliment_data_editor/presentation/widgets/editor_inputs/nutrient_input.dart';
import 'package:live_vitalist/features/aliment_editor/aliment_data_editor/presentation/widgets/json_editor_button.dart';
import 'package:live_vitalist/features/aliment_editor/aliment_data_editor/presentation/widgets/save_alert.dart';
import 'package:live_vitalist/features/nutrient/data/nutrient_provider.dart';

class TemporaryAlimentEditor extends ConsumerStatefulWidget {
  final AlimentData initialData;

  const TemporaryAlimentEditor({required this.initialData, super.key});

  @override
  ConsumerState<TemporaryAlimentEditor> createState() =>
      _TemporaryAlimentEditorState();
}

class _TemporaryAlimentEditorState
    extends ConsumerState<TemporaryAlimentEditor> {
  AlimentData data = AlimentData.empty;

  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    data = AlimentData.fromJson(widget.initialData.toJson());
    _nameController = TextEditingController(text: data.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get isModified =>
      jsonEncode(data.toJson()) != jsonEncode(widget.initialData.toJson());

  void _popSave() => Navigator.pop(context, data);
  void _popCancel() => Navigator.pop(context, null);

  Future<bool?> _showSaveAlert(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => SaveAlert(),
    );
  }

  Future<void> _confirmPop() async {
    if (!isModified) return _popCancel();

    final shouldSave = await _showSaveAlert(context);
    if (shouldSave == true) {
      _popSave();
    } else if (shouldSave == false) {
      _popCancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final nutrients = ref.watch(nutrientsProvider);
    final selectedNutrients = nutrients.order.where((key) =>
        key != 'kcals' && !nutrients.data[key]!.tags.contains('disabled'));

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmPop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Aliment Editor'),
          actions: [
            JsonEditorButton(
              data: data,
              onResult: (newData) {
                data = newData;
                setState(() => _nameController.text = data.name);
              },
            ),
          ],
        ),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  children: [
                    EditorStringInput(
                      'Name',
                      data.name,
                      (value) {
                        setState(() => data = data.copyWith(name: value));
                      },
                      _nameController,
                    ),
                    NutrientInput('kcals', nutrients, data),
                    ...selectedNutrients.map(
                      (key) => NutrientInput(key, nutrients, data),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _popSave,
                    child: const Text('Save'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
