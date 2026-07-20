import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/features/aliment/domain/aliment_data.dart';
import 'package:live_vitalist/features/aliment_editor/aliment_data_editor/presentation/widgets/save_alert.dart';
import 'package:live_vitalist/features/aliment_editor/aliment_data_editor/presentation/widgets/aliment_data_form.dart';
import 'package:live_vitalist/features/aliment_editor/aliment_data_editor/presentation/widgets/json_editor_button.dart';

class AlimentDataEditor extends ConsumerStatefulWidget {
  final AlimentData initialData;
  const AlimentDataEditor({required this.initialData, super.key});

  @override
  ConsumerState<AlimentDataEditor> createState() => _AlimentDataEditorState();
}

class _AlimentDataEditorState extends ConsumerState<AlimentDataEditor> {
  AlimentData data = AlimentData.empty;

  late final TextEditingController _nameController;
  late final TextEditingController _unitController;

  @override
  void initState() {
    super.initState();
    data = AlimentData.fromJson(widget.initialData.toJson());
    _nameController = TextEditingController();
    _unitController = TextEditingController();
    _updateControllers();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  void _updateControllers() {
    _nameController.text = data.name;
    _unitController.text = data.unit;
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _confirmPop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Aliment Editor'),
          actions: [
            JsonEditorButton(
              data: data,
              onResult: (newData) {
                data = newData;
                setState(() => _updateControllers());
              },
            ),
          ],
        ),
        body: AlimentDataForm(
          data: data,
          nameController: _nameController,
          unitController: _unitController,
          onDataChanged: (newData) => setState(() => data = newData),
          onSave: _popSave,
        ),
      ),
    );
  }
}
