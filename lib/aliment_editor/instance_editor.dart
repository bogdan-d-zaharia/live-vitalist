import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:diacritic/diacritic.dart';
import 'package:live_vitalist/aliment/aliment_data.dart';

import 'package:live_vitalist/aliment/aliment.dart';
import 'package:live_vitalist/aliment/aliment_bank.dart';
import 'package:live_vitalist/custom_card.dart';
import 'package:live_vitalist/palette.dart';
import 'package:live_vitalist/string_input.dart';
import 'aliment_data_editor.dart';

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

  Widget _buildAlimentSelector() {
    final name = selectedAliment?.name ?? 'Select aliment';

    return MiniCard(
      child: InkWell(
        onTap: _selectAliment,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                child: Text(
                  name,
                  softWrap: true,
                  style: TextStyle(
                    color: selectedAliment != null ? null : Colors.grey[700],
                  ),
                ),
              ),
            ),
            const Icon(Icons.arrow_drop_down_rounded, size: 42.0),
          ],
        ),
      ),
    );
  }

  Widget _buildServedInput() {
    return Row(
      children: [
        Text('Served amount:', style: Theme.of(context).textTheme.bodyLarge),
        Expanded(
          child: Center(
            child: NumberInput(
              getValue: () => aliment.servingSize,
              setValue: (val) {
                if (val >= 0.0) aliment = aliment.copyWith(servingSize: val);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget? _buildUnitSelector() {
    final data = selectedAliment;
    if (data == null) return null;

    final units = [data.unit, ...data.unitSynonyms.keys];

    return DropdownButton<String>(
      isExpanded: true,
      value: units.contains(aliment.unit) ? aliment.unit : null,
      items: units.map((unit) {
        return DropdownMenuItem(
          value: unit,
          child: SizedBox(width: 300.0, child: Text(unit)),
        );
      }).toList(),
      onChanged: (unit) {
        if (unit != null) {
          setState(() => aliment = aliment.copyWith(unit: unit));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final unitSelector = _buildUnitSelector();

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
                _buildAlimentSelector(),
                _buildServedInput(),
                if (unitSelector != null) unitSelector,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Selector extends ConsumerStatefulWidget {
  const Selector({super.key});
  @override
  ConsumerState<Selector> createState() => _SelectorState();
}

class _SelectorState extends ConsumerState<Selector> {
  final TextEditingController controller = TextEditingController();
  String searchTerm = '';

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bank = ref.watch(alimentBankProvider);
    final notifier = ref.read(alimentBankProvider.notifier);

    List<String> filteredKeys = bank.order.where((id) {
      final name = bank.aliments[id]!.name;
      return removeDiacritics(name.toLowerCase())
          .contains(removeDiacritics(searchTerm.toLowerCase()));
    }).toList();

    return MiniCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        child: Column(
          children: [
            Row(
              children: const [
                BackButton(),
                Text('Aliment Selector', style: TextStyle(fontSize: 20.0)),
              ],
            ),
            _buildSearchBar(),
            _buildAddButton(notifier),
            const Divider(height: 24.0, color: Palette.divGrey),
            Expanded(
              child: ListView(
                children: filteredKeys.map((id) {
                  final name = bank.aliments[id]!.name;
                  return MiniCard(
                    child: InkWell(
                      onTap: () => Navigator.pop(context, id),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(name),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return MiniCard(
      child: Row(
        children: [
          const SizedBox(
            width: 42.0,
            height: 42.0,
            child: Icon(Icons.search_rounded),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Search aliment',
                border: InputBorder.none,
              ),
              onChanged: (text) {
                if (text != searchTerm) {
                  setState(() => searchTerm = text);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(AlimentBank notifier) {
    return MiniCard(
      child: InkWell(
        onTap: () async {
          final AlimentData? aliment = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AlimentDataEditor(initialData: AlimentData.empty),
            ),
          );
          if (aliment == null) return;

          final id = aliment.hashCode.toString();
          notifier.setAliment(id, aliment);
          setState(() {});
        },
        child: Row(
          children: const [
            SizedBox(width: 42.0, height: 42.0, child: Icon(Icons.add_rounded)),
            Text('Add Aliment'),
          ],
        ),
      ),
    );
  }
}
