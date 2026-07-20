import 'package:flutter/material.dart';
import 'package:live_vitalist/features/aliment_editor/aliment_data_editor/presentation/ui_helpers/synonym_controllers.dart';
import 'package:live_vitalist/features/aliment_editor/aliment_data_editor/presentation/widgets/editor_inputs/new_synonym_input.dart';
import 'package:live_vitalist/features/aliment_editor/aliment_data_editor/presentation/widgets/editor_inputs/unit_synonym_input.dart';

class UnitSynonymsEditor extends StatefulWidget {
  final Map<String, double> synonyms;
  final Function(Map<String, double>) onChanged;

  const UnitSynonymsEditor({
    required this.synonyms,
    required this.onChanged,
    super.key,
  });

  @override
  State<UnitSynonymsEditor> createState() => _UnitSynonymsEditorState();
}

class _UnitSynonymsEditorState extends State<UnitSynonymsEditor> {
  final SynonymControllers _controllers = SynonymControllers();
  final TextEditingController _newNameController = TextEditingController();
  final TextEditingController _newValueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controllers.sync(widget.synonyms);
  }

  @override
  void didUpdateWidget(covariant UnitSynonymsEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controllers.sync(widget.synonyms);
  }

  @override
  void dispose() {
    _newNameController.dispose();
    _newValueController.dispose();
    _controllers.dispose();
    super.dispose();
  }

  void _rename(String oldKey, String rawNewKey) {
    final newKey = rawNewKey.trim();
    if (newKey.isEmpty || newKey == oldKey) return;

    final newMap = Map<String, double>.from(widget.synonyms);
    newMap[newKey] = newMap.remove(oldKey)!;
    _controllers.rename(oldKey, newKey);

    widget.onChanged(newMap);
  }

  void _setValue(String key, double value) {
    final newMap = Map<String, double>.from(widget.synonyms);
    newMap[key] = value;
    widget.onChanged(newMap);
  }

  void _delete(String key) {
    _controllers.remove(key);
    final newMap = Map<String, double>.from(widget.synonyms)..remove(key);
    widget.onChanged(newMap);
  }

  void _add() {
    final key = _newNameController.text.trim();
    final val = double.tryParse(_newValueController.text.trim());

    if (key.isEmpty ||
        val == null ||
        val <= 0 ||
        widget.synonyms.containsKey(key)) {
      return;
    }

    _controllers.add(key, val);
    _newNameController.clear();
    _newValueController.clear();

    final newMap = Map<String, double>.from(widget.synonyms);
    newMap[key] = val;
    widget.onChanged(newMap);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...widget.synonyms.keys.map(
          (key) => UnitSynonymInput(
            nameController: _controllers.name(key),
            valueController: _controllers.value(key),
            onRename: (newKey) => _rename(key, newKey),
            onValueChanged: (value) => _setValue(key, value),
            onDelete: () => _delete(key),
          ),
        ),
        NewSynonymInput(
          nameController: _newNameController,
          valueController: _newValueController,
          onAdd: _add,
        ),
      ],
    );
  }
}
