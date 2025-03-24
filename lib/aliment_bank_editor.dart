import 'dart:convert';

import 'package:flutter/material.dart';
import 'aliment.dart';
import 'custom_card.dart';
import 'models/reference_fields_model.dart';
import 'string_input.dart';

class AlimentBankEditor extends StatefulWidget {
  const AlimentBankEditor({super.key});

  static Future<bool> addNewAliment(BuildContext context) async {
    final Map<String, dynamic> alimentJson = {
      "name": "",
      "referenceSize": 0.0,
    };

    if (await AlimentEditor.editAlimentJson(alimentJson, context)) {
      final Aliment newAliment = Aliment(name: '', referenceSize: 0.0);
      final String id = newAliment.hashCode.toString();
      AlimentBank.aliments[id] = newAliment;
      return true;
    }

    return false;
  }

  @override
  State<AlimentBankEditor> createState() => _AlimentBankEditorState();
}

class _AlimentBankEditorState extends State<AlimentBankEditor> {
  void deleteAtId(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: CustomCard(
            headerSpace: 0.0,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Are you sure you want to delete this aliment?',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 12.0),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 100.0,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // setState(() {
                          //   AlimentBank.aliments.remove(id);
                          // });
                          Navigator.pop(context);
                        },
                        label: Text("Keep"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.blue, // Red color for delete action
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.0),
                    SizedBox(
                      width: 100.0,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            AlimentBank.aliments.remove(id);
                          });
                          // TODO: ACTUALLY DELETE IT.
                        },
                        icon: Icon(Icons.delete, color: Colors.white),
                        label: Text("Delete"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.red, // Red color for delete action
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> elements = AlimentBank.aliments.keys
        .map<Widget>(
          (id) => InkWell(
            onTap: () => setState(() {
              // final alimentJson = AlimentBank.getAliment(id).toJson();
              // AlimentJsonEditor.editAlimentJson(alimentJson, context);
              // AlimentBank.aliments[id] = Aliment.fromJson(alimentJson);

              AlimentEditor.editAliment(AlimentBank.aliments[id]!, context);
            }),
            onLongPress: () => deleteAtId(id),
            child: CustomCard(
              // title: '',
              headerSpace: 0.0,
              child: Text(AlimentBank.getAliment(id).name),
            ),
          ),
          // (id) => SizedBox(
          //   height: 100.0,
          //   child: Material(
          //     color: Colors.blue,
          //     child: InkWell(
          //       onTap: () => setState(() {
          //         AlimentBankEditor.editAliment(id, context);
          //       }),
          //       onLongPress: () {
          //         setState(() {
          //           AlimentBank.aliments.remove(id);
          //         });
          //       },
          //       child: Center(
          //         child: SizedBox(child: Text(AlimentBank.aliments[id]!.name)),
          //       ),
          //     ),
          //   ),
          // ),
        )
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Aliment Table Editor'),
      ),
      body: ListView(
        children: elements,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() {
          AlimentBankEditor.addNewAliment(context);
        }),
        child: Icon(Icons.add_rounded, color: Colors.white, size: 40.0),
      ),
    );
  }
}

abstract final class AlimentEditor {
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

  static Future<bool> editAliment(Aliment aliment, BuildContext context) async {
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
    Map<String, double?> expandedFields =
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
