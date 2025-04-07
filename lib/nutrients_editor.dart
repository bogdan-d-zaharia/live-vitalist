import 'package:flutter/material.dart';
import 'models/reference_fields_model.dart';
import 'string_input.dart';

class NutrientsEditor extends StatefulWidget {
  const NutrientsEditor({super.key});

  @override
  State<NutrientsEditor> createState() => _NutrientsEditorState();
}

class _NutrientsEditorState extends State<NutrientsEditor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nutrients Editor'),
        actions: [
          Container(
            /* 50.0 by default. */
            width: 42.0,
            height: 42.0,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(21.0),
              border: Border.all(
                  width: 1.0, strokeAlign: BorderSide.strokeAlignInside),
            ),
            child: IconButton(
                onPressed: () async {
                  final bool b = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Scaffold(
                            appBar: AppBar(
                              title: Text('Nutrients Json Editor'),
                            ),
                            body:
                                BetterJsonEditor(json: NutrientsHandler.model),
                          ),
                        ),
                      ) ??
                      false;

                  if (b) {
                    setState(() {});
                  }
                },
                icon: Icon(Icons.code)),
          ),
          SizedBox(width: 12.0),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: NutrientsHandler.model.keys.map<Widget>((e) {
            final field = NutrientsHandler.model[e]!;
            final String label = '${field['translations']['ENG']} ("$e")';

            return Card(
              child: InkWell(
                onTap: () async {
                  final Map<String, dynamic> fields = {
                    'Label': field['translations']['ENG'],
                    'Upper limit': field['upperLimit'],
                    'Lower limit': field['lowerLimit'],
                    'Unit': field['unit'],
                  };

                  final bool isModified = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        appBar: AppBar(
                          title: Row(
                            children:
                                NutrientsHandler.widMajorMinorLabels(label),
                          ),
                        ),
                        body: FieldsInput(fields: fields),
                      ),
                    ),
                  );

                  if (isModified) {
                    field['unit'] = fields['Unit'];
                    field['lowerLimit'] = fields['Lower limit'];
                    field['upperLimit'] = fields['Upper limit'];
                    field['translations']['ENG'] = fields['Label'];
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 4.0,
                  ),
                  child: Row(
                    children: [
                      ...NutrientsHandler.widMajorMinorLabels(label),
                      Spacer(),
                      Switch(
                        value: !(field['tags'] ?? []).contains('disabled'),
                        onChanged: (isTrue) {
                          if (!field.containsKey('tags')) {
                            field['tags'] = [];
                          }

                          setState(() {
                            if (isTrue) {
                              field['tags'].remove('disabled');
                            } else {
                              field['tags'].add('disabled');
                            }
                          });

                          if (field['tags'].isEmpty) {
                            field.remove('tags');
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
