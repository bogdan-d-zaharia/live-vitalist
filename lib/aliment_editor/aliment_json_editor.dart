import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/arta.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:highlight/languages/json.dart';

import '../aliment/aliment.dart';
import '../custom_card.dart';
import '../json_handler.dart';
import '../nutrient/nutrient_provider.dart';

class AlimentJsonEditor extends ConsumerStatefulWidget {
  const AlimentJsonEditor({
    required this.alimentData,
    super.key,
  });

  final AlimentData alimentData;

  @override
  ConsumerState<AlimentJsonEditor> createState() => _AlimentJsonEditorState();
}

class _AlimentJsonEditorState extends ConsumerState<AlimentJsonEditor> {
  late CodeController controller;
  late String originalText;

  @override
  void initState() {
    super.initState();
    originalText = widget.alimentData
        .toExpandedWithUnitsJson(ref.read(nutrientStateProvider));
    controller = CodeController(language: json, text: originalText);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void popSave() {
    if (controller.text == originalText) {
      return Navigator.pop(context, false);
    }

    try {
      widget.alimentData.mutateByJson(widget.alimentData
          .fromExpandedJsonWithCommentsToJsonMap(controller.text));

      Navigator.pop(context, true);
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: CustomCard(
              headerSpace: 0.0,
              child: Text('${e.toString()}\n'),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aliment Json Editor'),
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0).copyWith(bottom: 0.0),
        child: ListView(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 400.0,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: artaTheme['root']!.backgroundColor,
                borderRadius: BorderRadius.circular(24.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.8),
                    blurRadius: 6.0,
                    offset: Offset(0.0, 2.0),
                  )
                ],
              ),
              child: CodeTheme(
                data: CodeThemeData(styles: artaTheme),
                child: SingleChildScrollView(
                  child: CodeField(
                    controller: controller,
                    textStyle: TextStyle(fontSize: 13.5),
                    gutterStyle: GutterStyle(
                      showLineNumbers: false,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.0),
            Row(
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.restore),
                  label: Text('restore'),
                  onPressed: () =>
                      setState(() => controller.text = originalText),
                ),
                Spacer(),
                ElevatedButton.icon(
                  icon: Icon(Icons.edit_rounded),
                  label: Text('save'),
                  onPressed: popSave,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//TODO: Perhaps make it modify a dynamic,
// so that it can be a list, a map of <dynamic, dynamic>, a primitive.
class JsonEditor extends StatefulWidget {
  const JsonEditor({
    required this.json,
    super.key,
  });

  final Map<String, dynamic> json;

  @override
  State<JsonEditor> createState() => _JsonEditorState();
}

class _JsonEditorState extends State<JsonEditor> {
  late CodeController controller;
  late String originalText;

  @override
  void initState() {
    super.initState();
    originalText = JsonHandler.decodeIndented(widget.json);
    controller = CodeController(language: json, text: originalText);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 400.0,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: artaTheme['root']!.backgroundColor,
            borderRadius: BorderRadius.circular(24.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.8),
                blurRadius: 6.0,
                offset: Offset(0.0, 2.0),
              )
            ],
          ),
          child: CodeTheme(
            data: CodeThemeData(styles: artaTheme),
            child: SingleChildScrollView(
              child: CodeField(
                controller: controller,
                textStyle: TextStyle(fontSize: 13.5),
                gutterStyle: GutterStyle(
                  showLineNumbers: false,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 12.0),
        Row(
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.restore),
              label: Text('restore'),
              onPressed: () => setState(() => controller.text = originalText),
            ),
            Spacer(),
            ElevatedButton.icon(
              icon: Icon(Icons.edit_rounded),
              label: Text('save'),
              onPressed: () {
                if (controller.text == originalText) {
                  return Navigator.pop(context, false);
                }

                try {
                  widget.json.clear();
                  widget.json.addAll(
                    JsonHandler.processJson(
                      jsonDecode(controller.fullText),
                      removeNulls: true,
                    ),
                  );

                  Navigator.pop(context, true);
                } catch (e) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        backgroundColor: Colors.transparent,
                        child: CustomCard(
                          headerSpace: 0.0,
                          child: Text(
                              '${e.toString()}\n\n\n${widget.json.runtimeType}'),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
