import 'package:flutter/material.dart';
import '../aliment.dart';
import '../aliment_bank_editor.dart';
import '../custom_card.dart';
import '../palette.dart';
import '../string_input.dart';
import 'package:diacritic/diacritic.dart';

class InstanceEditor extends StatefulWidget {
  const InstanceEditor({
    required this.aliment,
    super.key,
  });
  final InstancedAliment aliment;

  @override
  State<InstanceEditor> createState() => _InstanceEditorState();
}

class _InstanceEditorState extends State<InstanceEditor> {
  bool isAlimentModified = false;
  bool isModified = false;

  Future<void> showSelector() async {
    final String? id = await showDialog(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 36.0),
        child: Selector(),
      ),
    );

    if (id == null) return;

    setState(() {
      isModified = true;
      isAlimentModified = true;

      widget.aliment.alimentID = id;

      final AlimentData aliment = AlimentBank.getAliment(id);
      widget.aliment.unit = aliment.unitSizes?.keys.first;
    });
  }

  //TODO: Perhaps use this as screen and number input to the right
  // also perhaps search and at the bottom instead of top, to be
  // easely accessible, or perhaps reverse everything.
  Widget _alimentSelector() {
    final String? name = AlimentBank.aliments[widget.aliment.alimentID]?.name;
    return MiniCard(
      child: InkWell(
        onTap: showSelector,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                child: Text(
                  name ?? 'Select aliment',
                  softWrap: true,
                  style: name != null
                      ? TextStyle()
                      : TextStyle().copyWith(color: Colors.grey[700]),
                ),
              ),
            ),
            Icon(Icons.arrow_drop_down_rounded, size: 42.0),
          ],
        ),
      ),
    );
  }

  Widget _inputServed() {
    return Row(
      children: [
        Text(
          'Served amount: ',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Expanded(
          child: Center(
            child: NumberInput(
              getValue: () => widget.aliment.servingSize,
              setValue: (val) {
                if (val >= 0.0) {
                  isModified = true;
                  return widget.aliment.servingSize = val;
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget? _unitSelector() {
    if (!AlimentBank.aliments.containsKey(widget.aliment.alimentID)) {
      return null;
    }
    final AlimentData aliment = widget.aliment.getAliment;
    final List<String>? units = aliment.unitSizes?.keys.toList();
    if (units == null) return null;

    return SizedBox(
      child: DropdownButton<String>(
        isExpanded: true,
        hint: Text(widget.aliment.unit ?? ''),

        //TODO:NOW: Handle the case when there is null unitSizes.
        items: units
            .map((unit) => DropdownMenuItem(
                value: unit, child: SizedBox(width: 300.0, child: Text(unit))))
            .toList(),
        onChanged: (unit) {
          if (unit != null) {
            setState(() {
              isModified = true;
              widget.aliment.unit = unit;
            });
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget? unitSelector = _unitSelector();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pop(context, (isModified, isAlimentModified));
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Editor'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _alimentSelector(),
                _inputServed(),
                if (unitSelector != null) unitSelector,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Selector extends StatefulWidget {
  const Selector({super.key});

  @override
  State<Selector> createState() => _SelectorState();
}

class _SelectorState extends State<Selector> {
  String searchTerm = '';
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keys = AlimentBank.sortedKeys.where((id) =>
        removeDiacritics(AlimentBank.getAliment(id).name.toLowerCase())
            .contains(removeDiacritics(searchTerm.toLowerCase())));
    return MiniCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        child: Column(
          children: [
            Row(
              children: [
                BackButton(),
                Text(
                  'Aliment Selector',
                  style: TextStyle(fontSize: 20.0),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                children: [
                  MiniCard(
                    child: Row(
                      children: [
                        SizedBox(
                          //TODO: A more programatical approach
                          width: 42.0,
                          height: 42.0,
                          child: Icon(Icons.search_rounded),
                        ),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                                hintText: 'Search aliment',
                                border: InputBorder.none),
                            style: Theme.of(context).textTheme.bodyMedium,
                            controller: controller,
                            onChanged: (newString) {
                              if (searchTerm == newString) return;
                              setState(() {
                                searchTerm = newString;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  MiniCard(
                    child: InkWell(
                      onTap: () => AlimentBankEditor.addNewAliment(context,
                              name: searchTerm)
                          .then((_) => setState(() {})),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 42.0,
                            height: 42.0,
                            child: Icon(Icons.add_rounded),
                          ),
                          Text('Add Aliment'),
                        ],
                      ),
                    ),
                  ),
                  Divider(height: 24.0, color: Palette.divGrey),
                  ...keys.map(
                    (id) => MiniCard(
                      child: InkWell(
                        onTap: () => Navigator.pop(context, id),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(AlimentBank.getAliment(id).name),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
