import 'dart:convert';

import 'package:flutter/material.dart';
import 'aliment.dart';
import 'aliment_bank_editor.dart';
import 'models/reference_fields_model.dart';
import 'string_input.dart';

abstract final class AlimentEditor {
  static Future<void> editInstancedAliment(
      InstancedAliment aliment, BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InstancedAlimentEditor(aliment: aliment),
      ),
    );
  }

  static Future<bool> editTemporaryAliment(
      TemporaryAliment temporaryAliment, BuildContext context) async {
    bool didSave = false;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            TemporaryAlimentEditor(temporaryAliment: temporaryAliment),
      ),
    ).then(
      (didSave2) {
        if (didSave2 != null) didSave = didSave2;
      },
    );
    return didSave;
  }

  static Future<bool> editAlimentJson(
      Map<String, dynamic> alimentJson, BuildContext context) async {
    bool didSave = false;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AlimentJsonEditor(alimentJson: alimentJson),
      ),
    ).then(
      (didSave2) {
        if (didSave2 != null) didSave = didSave2;
      },
    );
    return didSave;
  }

  static Future<bool> editAliment(
      AlimentData aliment, BuildContext context) async {
    bool didSave = false;

    final Map<String, dynamic> alimentJson = aliment.toJson();
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AlimentJsonEditor(alimentJson: alimentJson),
      ),
    ).then(
      (didSave2) {
        if (didSave2 != null) didSave = didSave2;
      },
    );

    /* We need to edit the same instance,
     and can't replace it with a new one. */
    if (didSave) {
      if (alimentJson.containsKey('name')) {
        aliment.name = alimentJson['name'];
      }
      if (alimentJson.containsKey('referenceSize')) {
        aliment.referenceSize = alimentJson['referenceSize'];
      }
      if (alimentJson.containsKey('referenceFields')) {
        aliment.referenceFields =
            (alimentJson['referenceFields'] as Map<String, dynamic>)
                .map<String, double>(
                    (key, value) => MapEntry(key, value as double));
      }
      if (alimentJson.containsKey('unitSizes')) {
        aliment.unitSizes = (alimentJson['unitSizes'] as Map<String, dynamic>)
            .map<String, double>(
                (key, value) => MapEntry(key, value as double));
      }
    }

    return didSave;
  }
}

class AlimentJsonEditor extends StatelessWidget {
  const AlimentJsonEditor({
    required this.alimentJson,
    super.key,
  });

  final Map<String, dynamic> alimentJson;

  @override
  Widget build(BuildContext context) {
    final Map<String, double?> expandedFields =
        NutrientsHandler.model.map((key, value) => MapEntry(key, null));

    for (var entry in alimentJson['referenceFields'].entries) {
      expandedFields[entry.key] = entry.value;
    }

    alimentJson['referenceFields'] = expandedFields;
    final String alimentJsonString =
        JsonEncoder.withIndent('  ').convert(alimentJson);

    return Scaffold(
      appBar: AppBar(
        title: Text('Aliment Editor'),
      ),
      body: JsonEditor(
        initString: alimentJsonString,
        update: (p0) {
          final Map<String, dynamic> newAlimentJson = jsonDecode(p0);
          (newAlimentJson['referenceFields'] as Map<String, dynamic>)
              .removeWhere((key, value) => (value == null));

          alimentJson.clear();
          alimentJson.addAll(newAlimentJson);

          Navigator.pop(context, true);
        },
      ),
    );
  }
}

class TemporaryAlimentEditor extends StatelessWidget {
  const TemporaryAlimentEditor({
    required this.temporaryAliment,
    super.key,
  });

  final TemporaryAliment temporaryAliment;

  Widget _inputServed() {
    return StringInput(
      hint: 'Served amount',
      initString: temporaryAliment.servingSize.toString(),
      keyboardType: TextInputType.number,
      update: (p0) {
        // setState(() {
        double? value = double.tryParse(p0);
        if (value != null) {
          temporaryAliment.servingSize = value;
        }
        // });
      },
    );
  }

  Widget? _unitSelector() {
    final AlimentData aliment = temporaryAliment.getAliment;
    final List<String>? units = aliment.unitSizes?.keys.toList();
    if (units == null) return null;

    return SizedBox(
      child: DropdownButton<String>(
        isExpanded: true,
        hint: Text(temporaryAliment.unit ?? ''),

        //TODO:NOW: Handle the case when there is null unitSizes.
        items: units
            .map((unit) => DropdownMenuItem(
                value: unit, child: SizedBox(width: 300.0, child: Text(unit))))
            .toList(),
        onChanged: (unit) {
          if (unit != null) {
            // setState(() {
            temporaryAliment.unit = unit;
            // });
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget? unitSelector = _unitSelector();

    final Map<String, dynamic> alimentJson =
        temporaryAliment.alimentData.toJson();

    final Map<String, double?> expandedFields =
        NutrientsHandler.model.map((key, value) => MapEntry(key, null));

    for (var entry in alimentJson['referenceFields'].entries) {
      expandedFields[entry.key] = entry.value;
    }

    alimentJson['referenceFields'] = expandedFields;
    final String alimentJsonString =
        JsonEncoder.withIndent('  ').convert(alimentJson);

    return Scaffold(
      appBar: AppBar(
        title: Text('Temporary Aliment Editor'),
      ),
      body: Column(
        children: [
          _inputServed(),
          if (unitSelector != null) unitSelector,
          JsonEditor(
            initString: alimentJsonString,
            update: (p0) {
              final Map<String, dynamic> newAlimentJson = jsonDecode(p0);
              (newAlimentJson['referenceFields'] as Map<String, dynamic>)
                  .removeWhere((key, value) => (value == null));

              temporaryAliment.alimentData =
                  AlimentData.fromJson(newAlimentJson);

              Navigator.pop(context, true);
            },
          ),
        ],
      ),
    );
  }
}

class InstancedAlimentEditor extends StatefulWidget {
  const InstancedAlimentEditor({
    required this.aliment,
    super.key,
  });
  final InstancedAliment aliment;

  @override
  State<InstancedAlimentEditor> createState() => _InstancedAlimentEditorState();
}

class _InstancedAlimentEditorState extends State<InstancedAlimentEditor> {
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
            AlimentBank.aliments.keys

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
    return StringInput(
      hint: 'Served amount',
      initString: widget.aliment.servingSize.toString(),
      keyboardType: TextInputType.number,
      update: (p0) {
        setState(() {
          double? value = double.tryParse(p0);
          if (value != null) {
            widget.aliment.servingSize = value;
          }
        });
      },
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
    return Scaffold(
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
                  onTap: () => setState(() {
                    AlimentBankEditor.addNewAliment(context);
                  }),
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
    );
  }
}
