import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../aliment/aliment.dart';
import '../custom_card.dart';
import '../nutrient/nutrient_provider.dart';
import '../string_input.dart';
import 'aliment_json_editor.dart';

class AlimentDataEditor extends ConsumerStatefulWidget {
  const AlimentDataEditor({
    required this.data,
    super.key,
  });

  final AlimentData data;

  @override
  ConsumerState<AlimentDataEditor> createState() => _AlimentDataEditorState();
}

class _AlimentDataEditorState extends ConsumerState<AlimentDataEditor> {
  NutrientState get nutrients => ref.watch(nutrientStateProvider);

  late AlimentData editableData;
  bool isShowAdvanced = false;

  final Map<String, TextEditingController> _nameControllers = {};
  final Map<String, TextEditingController> _valueControllers = {};
  late final TextEditingController _newSynonymNameController;
  late final TextEditingController _newSynonymValueController;
  late final TextEditingController _nameController;
  late final TextEditingController _unitController;

  @override
  void initState() {
    super.initState();
    editableData = AlimentData.fromJson(widget.data.toJson());

    _newSynonymNameController = TextEditingController();
    _newSynonymValueController = TextEditingController();

    _nameController = TextEditingController();
    _unitController = TextEditingController();

    for (var entry in editableData.unitSynonyms.entries) {
      _nameControllers[entry.key] = TextEditingController();
      _valueControllers[entry.key] = TextEditingController();
    }

    updateControllers();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _unitController.dispose();
    _newSynonymNameController.dispose();
    _newSynonymValueController.dispose();
    for (final ctrl in _nameControllers.values) {
      ctrl.dispose();
    }
    for (final ctrl in _valueControllers.values) {
      ctrl.dispose();
    }
    super.dispose();
  }

  void updateControllers() {
    _nameController.text = editableData.name;
    _unitController.text = editableData.unit;

    for (var x in List.from(_nameControllers.keys)) {
      if (!editableData.unitSynonyms.containsKey(x)) {
        _nameControllers[x]?.dispose();
        _valueControllers[x]?.dispose();
        _nameControllers.remove(x);
        _valueControllers.remove(x);
      }
    }

    for (var entry in editableData.unitSynonyms.entries) {
      if (_nameControllers[entry.key] != null) {
        _nameControllers[entry.key]!.text = entry.key;
        _valueControllers[entry.key]!.text = entry.value.toString();
      } else {
        _nameControllers[entry.key] = TextEditingController(text: entry.key);
        _valueControllers[entry.key] =
            TextEditingController(text: entry.value.toString());
      }
    }
  }

  bool get isModified =>
      jsonEncode(editableData.toJson()) != jsonEncode(widget.data.toJson());

  void _popSave() {
    widget.data.mutateByJson(editableData.toJson());
    Navigator.pop(context, true);
  }

  void _popCancel() {
    Navigator.pop(context, false);
  }

  Future<bool?> _showSaveAlert() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save changes?'),
        content: const Text('Do you want to save this aliment?'),
        actions: [
          TextButton(onPressed: _popCancel, child: const Text('Cancel')),
          ElevatedButton(onPressed: _popSave, child: const Text('Save')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final basicFields = ['kcals', 'protein', 'carbs', 'fats'];
    final advancedFields = nutrients.order
        .where((k) =>
            !basicFields.contains(k) &&
            !nutrients.data[k]!.tags.contains('disabled'))
        .toList();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (!isModified) return _popCancel();

        final shouldSave = await _showSaveAlert();
        if (shouldSave == true) {
          _popSave();
        } else if (shouldSave == false) {
          _popCancel();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Aliment Editor'),
          actions: [
            IconButton(
              onPressed: () async {
                final isMutate = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AlimentJsonEditor(
                          alimentData: editableData,
                        ),
                      ),
                    ) ??
                    false;
                if (isMutate) setState(() => updateControllers());
              },
              icon: Icon(Icons.code_rounded),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ListView(
            children: [
              _stringInput(
                'Name',
                editableData.name,
                (val) => setState(() => editableData.name = val),
                _nameController,
              ),
              _stringInput(
                'Unit',
                editableData.unit,
                (val) => setState(() => editableData.unit = val),
                _unitController,
              ),
              _numberInput(
                'Per amount',
                () => editableData.referenceSize,
                (val) => setState(() => editableData.referenceSize = val),
                unit: editableData.unit,
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
                ...editableData.unitSynonyms.entries
                    .map((entry) => _unitSynonymInput(entry.key)),
                _addSynonymInput(),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _popSave,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stringInput(String label, String value,
      void Function(String) onChanged, TextEditingController controller) {
    return MiniCard(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Text('$label:'),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                style: Theme.of(context).textTheme.bodyMedium,
                controller: controller,
                onChanged: onChanged,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _numberInput(
    String label,
    double Function() getValue,
    void Function(double) setValue, {
    String? unit,
  }) {
    return MiniCard(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(child: Text('$label:', overflow: TextOverflow.ellipsis)),
            const SizedBox(width: 12),
            NumberInput(
              getValue: getValue,
              setValue: setValue,
              showHandles: false,
            ),
            if (unit != null) ...[
              const SizedBox(width: 12),
              Text(unit),
            ],
          ],
        ),
      ),
    );
  }

  Widget _nutrientInput(String key) {
    final model = nutrients.data[key];
    if (model == null) return const SizedBox();

    final label = model.translations['ENG']!;
    final unit = model.unit;

    return _numberInput(
      label,
      () => editableData.referenceFields[key] ?? 0.0,
      (val) => editableData.referenceFields[key] = val,
      unit: unit,
    );
  }

  Widget _unitSynonymInput(String key) {
    final nameCtrl = _nameControllers[key]!;
    final valueCtrl = _valueControllers[key]!;

    return MiniCard(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(hintText: 'Name'),
                onSubmitted: (newKey) {
                  newKey = newKey.trim();
                  if (newKey.isEmpty || newKey == key) return;

                  final newMap =
                      Map<String, double>.from(editableData.unitSynonyms);
                  final oldValue = newMap.remove(key)!;
                  newMap[newKey] = oldValue;

                  _nameControllers[newKey] = nameCtrl;
                  _valueControllers[newKey] = valueCtrl;
                  _nameControllers.remove(key);
                  _valueControllers.remove(key);

                  setState(() {
                    editableData.unitSynonyms = newMap;
                  });
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 1,
              child: TextField(
                controller: valueCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Value'),
                onSubmitted: (val) {
                  final parsed = double.tryParse(val.trim());
                  if (parsed == null || parsed <= 0) return;

                  setState(() {
                    editableData.unitSynonyms[key] = parsed;
                  });
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                _nameControllers[key]?.dispose();
                _valueControllers[key]?.dispose();
                _nameControllers.remove(key);
                _valueControllers.remove(key);

                setState(() {
                  editableData.unitSynonyms.remove(key);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _addSynonymInput() {
    return MiniCard(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: _newSynonymNameController,
                decoration: const InputDecoration(hintText: 'New unit name'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 1,
              child: TextField(
                controller: _newSynonymValueController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Value'),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                final key = _newSynonymNameController.text.trim();
                final val =
                    double.tryParse(_newSynonymValueController.text.trim());

                if (key.isNotEmpty &&
                    val != null &&
                    val > 0 &&
                    !editableData.unitSynonyms.containsKey(key)) {
                  setState(() {
                    editableData.unitSynonyms[key] = val;
                    _nameControllers[key] = TextEditingController(text: key);
                    _valueControllers[key] =
                        TextEditingController(text: val.toString());

                    _newSynonymNameController.clear();
                    _newSynonymValueController.clear();
                  });
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
