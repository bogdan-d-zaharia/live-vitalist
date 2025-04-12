import 'package:flutter/material.dart';
import '../aliment.dart';
import '../aliment_bank_editor.dart';
import '../string_input.dart';

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

  String searchTerm = '';

  Widget _alimentSelector() {
    return SizedBox(
      child: DropdownButton<String>(
        isExpanded: true,
        hint: ListView(
          children: [
            Text(AlimentBank.aliments[widget.aliment.alimentID]?.name ?? '')
          ],
        ),
        items:

            /// Filter for the search term.
            AlimentBank.sortedKeys

                /// TODO: Ideea e ca se actualizeaza cand iesi si intri in dropdown...
                /// .where((element) => false)
                /// Create the dropdown
                .map((id) => DropdownMenuItem(
                    enabled: (searchTerm == '') ||
                        (AlimentBank.getAliment(id)
                            .name
                            .toLowerCase()
                            .contains(searchTerm.toLowerCase())),
                    value: id,
                    child: SizedBox(
                        width: 300.0,
                        child: Text(AlimentBank.getAliment(id).name))))
                .toList()

        /// Add the search box.
        /// ..insert(
        ///     0,
        ///     DropdownMenuItem(
        ///       value: null,
        ///       child: SizedBox(
        ///         width: 300.0,
        ///         child: StringInput(
        ///           hint: 'Search',
        ///           update: (p0) {
        ///             setState(() {
        ///               searchTerm = p0;
        ///             });
        ///           },
        ///         ),
        ///       ),
        ///     ))
        ,
        onChanged: (newID) {
          if (newID != null) {
            setState(() {
              isModified = true;
              isAlimentModified = true;

              widget.aliment.alimentID = newID;

              final AlimentData aliment = AlimentBank.getAliment(newID);
              widget.aliment.unit = aliment.unitSizes?.keys.first;
            });
          }
        },
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

    // return StringInput(
    //   hint: 'Served amount',
    //   initString: widget.aliment.servingSize.toString(),
    //   keyboardType: TextInputType.number,
    //   update: (p0) {
    //     setState(() {
    //       double? value = double.tryParse(p0);
    //       if (value != null) {
    //         isModified = true;
    //         widget.aliment.servingSize = value;
    //       }
    //     });
    //   },
    // );
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
    // final newKeys = AlimentBank.aliments.keys
    //     // Filter elements in search.
    //     .where(
    //       (id) =>
    //           (searchTerm == '') ||
    //           (AlimentBank.getAliment(id).name
    //               .toLowerCase()
    //               .contains(searchTerm.toLowerCase())),
    //     )
    //     .toList();
    // print(newKeys);
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
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 24.0),
              child: SizedBox(
                width: 32.0,
                height: 32.0,
                child: Material(
                  borderRadius: BorderRadius.circular(8.0),
                  clipBehavior: Clip.hardEdge,
                  color: Colors.lightGreen,
                  child: InkWell(
                    splashColor: Colors.blue,
                    highlightColor: Colors.blue,
                    onTap: () => AlimentBankEditor.addNewAliment(context)
                        .then((_) => setState(() {})),
                    child: Icon(Icons.add_rounded, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
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
