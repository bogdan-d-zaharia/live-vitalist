import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/aliment/domain/aliment_data.dart';

import 'package:live_vitalist/aliment/domain/aliment.dart';
import 'package:live_vitalist/aliment/data/aliment_bank.dart';
import 'package:live_vitalist/aliment_editor/instance_editor/presentation/widgets/aliment_picker_field.dart';
import 'package:live_vitalist/aliment_editor/instance_editor/presentation/widgets/aliment_selector.dart';
import 'package:live_vitalist/aliment_editor/instance_editor/presentation/widgets/served_amount_input.dart';
import 'package:live_vitalist/aliment_editor/instance_editor/presentation/widgets/unit_dropdown.dart';

class InstanceEditor extends ConsumerStatefulWidget {
  const InstanceEditor({required this.initialAliment, super.key});
  final InstancedAliment initialAliment;

  @override
  ConsumerState<InstanceEditor> createState() => _InstanceEditorState();
}

class _InstanceEditorState extends ConsumerState<InstanceEditor> {
  late InstancedAliment aliment;

  bool get isModified =>
      jsonEncode(aliment.toJson()) !=
      jsonEncode(widget.initialAliment.toJson());

  void _pop() {
    Navigator.pop(context, isModified ? aliment : null);
  }

  @override
  void initState() {
    super.initState();
    aliment = InstancedAliment.fromJson(widget.initialAliment.toJson());
  }

  AlimentData? get selectedAliment =>
      ref.watch(alimentBankProvider).aliments[aliment.alimentID];

  Future<void> _selectAliment() async {
    final selectedId = await showDialog<String>(
      context: context,
      builder: (_) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 36.0),
        child: Selector(),
      ),
    );
    if (selectedId == null) return;

    final selected = ref.read(alimentBankProvider).aliments[selectedId];
    if (selected == null) return;

    aliment = aliment.copyWith(
      alimentID: selectedId,
      unit: selected.unit,
    );

    ref.read(alimentBankProvider.notifier).setFirst(selectedId);
  }

  @override
  Widget build(BuildContext context) {
    final data = selectedAliment;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _pop();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Editor')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AlimentPickerField(
                  alimentName: data?.name,
                  onTap: _selectAliment,
                ),
                ServedAmountInput(
                  getValue: () => aliment.servingSize,
                  setValue: (val) {
                    if (val >= 0.0) {
                      aliment = aliment.copyWith(servingSize: val);
                    }
                  },
                ),
                if (data != null)
                  UnitDropdown(
                    data: data,
                    currentUnit: aliment.unit,
                    onChanged: (unit) =>
                        setState(() => aliment = aliment.copyWith(unit: unit)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
