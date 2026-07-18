import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/arta.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:highlight/languages/json.dart';

import 'package:live_vitalist/aliment/domain/aliment_data.dart';
import 'package:live_vitalist/aliment/data/aliment_data_extensions.dart';
import 'package:live_vitalist/core/presentation/widgets/custom_card.dart';
import 'package:live_vitalist/nutrient/data/nutrient_provider.dart';

class AlimentJsonEditor extends ConsumerStatefulWidget {
  final AlimentData initialData;
  const AlimentJsonEditor({required this.initialData, super.key});

  @override
  ConsumerState<AlimentJsonEditor> createState() => _AlimentJsonEditorState();
}

class _AlimentJsonEditorState extends ConsumerState<AlimentJsonEditor> {
  late CodeController controller;
  late String originalText;

  @override
  void initState() {
    super.initState();
    originalText =
        widget.initialData.toExpandedWithUnitsJson(ref.read(nutrientsProvider));
    controller = CodeController(language: json, text: originalText);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool get isModified => controller.text != originalText;

  void popSave() {
    if (!isModified) return Navigator.pop(context, null);

    try {
      final data = AlimentData.fromJson(widget.initialData
          .fromExpandedJsonWithCommentsToJsonMap(controller.text));
      Navigator.pop(context, data);
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
