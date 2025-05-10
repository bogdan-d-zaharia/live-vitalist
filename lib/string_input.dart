import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:highlight/languages/json.dart';
import 'package:flutter_highlight/themes/arta.dart';

import 'custom_card.dart';
import 'json_handler.dart';
import 'palette.dart';

//TODO: I don't yet need it but it can be an upgrade.
// class StringField {
//   StringField({
//     required this.string,
//     required this.label,
//   });

//   String string;
//   String label;
// }

class FieldsInput extends StatefulWidget {
  const FieldsInput({
    required this.fields,
    super.key,
  });

  final Map<String, dynamic> fields;

  @override
  State<FieldsInput> createState() => _FieldsInputState();
}

class _FieldsInputState extends State<FieldsInput> {
  bool isModified = false;

  late List<TextEditingController> controllers;
  late List<TextInputType?> keyboardTypes;
  late Map<String, dynamic> editable;

  void setAtIndex(int i, dynamic val) {
    editable[editable.keys.elementAt(i)] = val;
  }

  @override
  void initState() {
    super.initState();
    editable = Map.of(widget.fields);
    controllers = editable.values
        .map((e) => TextEditingController(text: e?.toString() ?? ''))
        .toList();
    keyboardTypes = editable.values
        .map((e) =>
            e is String ? null : TextInputType.numberWithOptions(decimal: true))
        .toList();
  }

  @override
  void dispose() {
    for (final controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        for (int i = 0; i < editable.length; ++i) {
          final val = editable.values.elementAt(i);
          if (val != widget.fields.values.elementAt(i)) {
            widget.fields[widget.fields.keys.elementAt(i)] = val;
            isModified = true;
          }
        }

        Navigator.pop(context, isModified);
      },
      child: Card(
        margin: EdgeInsets.all(12.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              editable.length,
              (i) => Row(
                children: [
                  SizedBox(
                    width: 100.0,
                    child: Text(editable.keys.elementAt(i)),
                  ),
                  Expanded(
                    child: TextField(
                      style: Theme.of(context).textTheme.bodyMedium,
                      controller: controllers[i],
                      textInputAction: i < editable.length - 1
                          ? TextInputAction.next
                          : TextInputAction.done,
                      onChanged: (newString) {
                        final dynamic val = keyboardTypes[i] == null
                            ? (newString != '' ? newString : null)
                            : double.tryParse(newString);
                        setAtIndex(i, val);
                      },
                      keyboardType: keyboardTypes[i],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class StringInput extends StatefulWidget {
  const StringInput({
    super.key,
    this.initString,
    this.update,
    this.submit,
    this.keyboardType,
    this.decoration,
  });

  final String? initString;
  final Function(String)? update;
  final Function(String)? submit;
  final TextInputType? keyboardType;
  final InputDecoration? decoration;

  @override
  State<StringInput> createState() => _StringInputState();
}

class _StringInputState extends State<StringInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initString);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: widget.keyboardType,
      style: Theme.of(context).textTheme.bodyMedium,
      controller: _controller,
      decoration: widget.decoration ??
          const InputDecoration(
            border: UnderlineInputBorder(),
          ),
      onChanged: widget.update,
      onSubmitted: widget.submit,
    );
  }
}

class MultilineStringInput extends StatefulWidget {
  final String? initString;
  final Function(String)? update;

  const MultilineStringInput({
    super.key,
    this.initString,
    this.update,
  });

  @override
  State<MultilineStringInput> createState() => _MultilineStringInputState();
}

class _MultilineStringInputState extends State<MultilineStringInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initString);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: null,
      keyboardType: TextInputType.multiline,
      style: Theme.of(context).textTheme.bodyMedium,
      controller: _controller,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
      ),
      onChanged: widget.update,
    );
  }
}

//TODO: Perhaps make it modify a dynamic,
// so that it can be a list, a map of <dynamic, dynamic>, a primitive.
class JsonEditor extends StatefulWidget {
  const JsonEditor({
    required this.json,
    this.trimNulls = false,
    super.key,
  });

  final Map<String, dynamic> json;
  final bool trimNulls;

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

//TODO: Perhaps handle null getValue, so that there might be fields where it is
// for sure 0.0 and fields where it is assumed that is not specified.
class NumberInput extends StatefulWidget {
  const NumberInput({
    required this.getValue,
    required this.setValue,
    this.showHandles = true,
    this.isEmpty = false,
    this.isTurnedOff = false,
    super.key,
  });

  final double Function() getValue;
  final Function(double) setValue;
  final bool showHandles;
  final bool isEmpty;
  final bool isTurnedOff;

  @override
  State<NumberInput> createState() => _NumberInputState();
}

class _NumberInputState extends State<NumberInput> {
  late TextEditingController _controller;

  double get number => widget.getValue();
  set number(double val) => widget.setValue(val);

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget divider({double indent = 4.0, Color? color}) {
    return VerticalDivider(
      width: 0.0,
      indent: indent,
      endIndent: indent,
      color: color ?? Palette.divGrey,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double height = 42.0;

    _controller.text = widget.isEmpty ? '' : number.toString();

    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height / 2.0),
        color: (Palette.isDarkMode(context) ? Colors.black : Colors.white)
            .withValues(alpha: 0.8),
      ),
      clipBehavior: Clip.hardEdge,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.showHandles)
            SizedBox(
              width: height,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  child: Center(child: Icon(Icons.remove_rounded)),
                  onTap: () => setState(() {
                    number = number - 1.0;
                  }),
                ),
              ),
            ),
          if (widget.showHandles) divider(),
          SizedBox(
            width: 2.0 * height,
            height: height,
            child: !widget.isTurnedOff
                ? TextField(
                    expands: true,
                    maxLines: null,
                    minLines: null,
                    // style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    controller: _controller,
                    decoration: InputDecoration(border: InputBorder.none),
                    onChanged: (value) {
                      final double? v = double.tryParse(value);
                      if (v != null && v.isFinite) number = v;
                    },
                    onEditingComplete: () => setState(() {}),
                  )
                : null,
          ),
          if (widget.showHandles) divider(),
          if (widget.showHandles)
            SizedBox(
              width: height,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  child: Center(child: Icon(Icons.add_rounded)),
                  onTap: () => setState(() {
                    number = number + 1.0;
                  }),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
