import 'package:flutter/material.dart';
import 'custom_card.dart';
import 'json_handler.dart';
import 'models/reference_fields_model.dart';
import 'settings.dart';
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
                  final Map<String, dynamic> editable =
                      Map.of(NutrientsHandler.model);

                  final bool b = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Scaffold(
                            appBar: AppBar(
                              title: Text('Nutrients Json Editor'),
                            ),
                            body: Padding(
                              padding:
                                  EdgeInsets.all(12.0).copyWith(bottom: 0.0),
                              child: JsonEditor(json: editable),
                            ),
                          ),
                        ),
                      ) ??
                      false;

                  if (b) {
                    NutrientsHandler.model.clear();
                    NutrientsHandler.model.addAll(editable.map((key, value) =>
                        MapEntry(key, JsonHandler.processJson(value))));

                    setState(() {});
                  }
                },
                icon: Icon(Icons.code)),
          ),
          SizedBox(width: 12.0),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView(
          children: NutrientsHandler.model.keys.map<Widget>((e) {
            final field = NutrientsHandler.model[e]!;
            final String label =
                '${field['translations'][SettingsData.language]} ("$e")';

            return MiniCard(
              child: InkWell(
                onTap: () async {
                  final Map<String, dynamic> fields = {
                    'Label': field['translations'][SettingsData.language],
                    'Upper limit': field['upperLimit'],
                    'Lower limit': field['lowerLimit'],
                    'Unit': field['unit'],
                  };

                  final bool isModified = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        appBar: AppBar(
                          title: NutrientsHandler.widMajorMinorLabels2(
                              label, TextStyle()),
                        ),
                        body: FieldsInput(fields: fields),
                      ),
                    ),
                  );

                  if (isModified) {
                    field['unit'] = fields['Unit'];
                    field['lowerLimit'] = fields['Lower limit'];
                    field['upperLimit'] = fields['Upper limit'];
                    field['translations'][SettingsData.language] =
                        fields['Label'];
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 4.0,
                  ),
                  child: Row(
                    children: [
                      NutrientsHandler.widMajorMinorLabels2(
                          label, Theme.of(context).textTheme.bodyMedium!),
                      Spacer(),
                      Switch(
                        value: !(field['tags'] ?? []).contains('disabled'),
                        onChanged: (isTrue) {
                          //TODO: Replace with switch Tag in nutrients editor
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
          }).toList()
            ..add(SizedBox(height: 12.0)),
        ),
      ),
    );
  }
}
