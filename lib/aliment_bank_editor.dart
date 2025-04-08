import 'package:flutter/material.dart';
import 'aliment.dart';
import 'aliment_editor/aliment_editor.dart';
import 'custom_card.dart';

class AlimentBankEditor extends StatefulWidget {
  const AlimentBankEditor({super.key});

  static Future<bool> addNewAliment(BuildContext context) async {
    final Map<String, dynamic> alimentJson = {
      "name": "",
      "referenceSize": 0.0,
    };

    if (await AlimentEditor.editAlimentJson(alimentJson, context)) {
      final AlimentData newAliment = AlimentData.fromJson(alimentJson);
      final String id = newAliment.hashCode.toString();
      AlimentBank.aliments[id] = newAliment;
      AlimentBank.save();
      return true;
    }

    return false;
  }

  static Future<bool> editAliment(String id, BuildContext context) async {
    final alimentJson = AlimentBank.getAliment(id).toJson();

    if (await AlimentEditor.editAlimentJson(alimentJson, context)) {
      final AlimentData aliment = AlimentData.fromJson(alimentJson);
      AlimentBank.aliments[id] = aliment;
      AlimentBank.save();
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
                          Navigator.pop(context);
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
    final List<Widget> elements = AlimentBank.aliments.keys.map<Widget>(
      (id) {
        //TODO: Did a little wizzardry.
        final aliment = InstancedAliment(alimentID: id, servingSize: 0.0);

        return Card(
          child: InkWell(
            onTap: () => AlimentEditor.editAliment(aliment, context)
                .then((_) => setState(() {})),
            onLongPress: () => deleteAtId(id),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 20.0,
              ),
              child: Text(aliment.getAliment.name),
            ),
          ),
        );
      },
    ).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Aliment Table Editor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: elements,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AlimentBankEditor.addNewAliment(context)
            .then((_) => setState(() {})),
        child: Icon(Icons.add_rounded, color: Colors.white, size: 40.0),
      ),
    );
  }
}
