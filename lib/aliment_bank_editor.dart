import 'dart:convert';

import 'package:flutter/material.dart';
import 'aliment.dart';
import 'custom_card.dart';
import 'models/reference_fields_model.dart';
import 'string_input.dart';

class AlimentBankEditor extends StatefulWidget {
  const AlimentBankEditor({super.key});

  static Future<bool> editAliment(String id, BuildContext context) async {
    bool didSave = false;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AlimentBankElement(alimentID: id),
      ),
    ).then(
      (didSave2) {
        if (didSave2 != null) didSave = didSave2;
      },
    );
    return didSave;
  }

  static Future<bool> addNewAliment(BuildContext context) async {
    final Aliment newAliment = Aliment(name: '', referenceSize: 0.0);
    final String id = newAliment.hashCode.toString();
    AlimentBank.aliments[id] = newAliment;

    /// TODO: Try editing the aliment and if it is canceled,
    /// remove it from the bank.
    if (await editAliment(id, context)) {
      return true;
    } else {
      AlimentBank.aliments.remove(id);
      return false;
    }
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
              AlimentBankEditor.editAliment(id, context);
            }),
            onLongPress: () => deleteAtId(id),
            child: CustomCard(
              // title: '',
              headerSpace: 0.0,
              child: Text(AlimentBank.aliments[id]!.name),
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

class AlimentBankElement extends StatefulWidget {
  const AlimentBankElement({
    required this.alimentID,
    super.key,
  });

  final String alimentID;

  @override
  State<AlimentBankElement> createState() => _AlimentBankElementState();
}

class _AlimentBankElementState extends State<AlimentBankElement> {
  late Map<String, dynamic> newAlimentJson;
  late String newAlimentJsonString;

  @override
  Widget build(BuildContext context) {
    newAlimentJson = AlimentBank.aliments[widget.alimentID]!.toJson();

    Map<String, double?> expandedFields =
        NutrientsHandler.model.map((key, value) => MapEntry(key, null));

    for (var entry in newAlimentJson['referenceFields'].entries) {
      expandedFields[entry.key] = entry.value;
    }

    newAlimentJson['referenceFields'] = expandedFields;
    newAlimentJsonString = JsonEncoder.withIndent('  ').convert(newAlimentJson);

    return Scaffold(
      appBar: AppBar(
        title: Text('Aliment Editor'),
      ),
      body: JsonEditor(
        initString: newAlimentJsonString,
        update: (p0) {
          newAlimentJson = jsonDecode(p0);
          (newAlimentJson['referenceFields'] as Map<String, dynamic>)
              .removeWhere((key, value) => (value == null));
          AlimentBank.aliments[widget.alimentID] =
              Aliment.fromJson(newAlimentJson);
          AlimentBank.save();
          Navigator.pop(context, true);
        },
      ),
    );
  }
}
