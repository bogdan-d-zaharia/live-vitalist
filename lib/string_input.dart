import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:highlight/languages/json.dart';
import 'package:flutter_highlight/themes/arta.dart';

class StringInput extends StatefulWidget {
  final String? hint;
  final String? initString;
  final Function(String)? update;
  final double? width;
  final TextInputType? keyboardType;

  const StringInput({
    super.key,
    this.hint,
    this.initString,
    this.update,
    this.width,
    this.keyboardType,
  });

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
    return SizedBox(
      width: widget.width,
      child: Row(
        children: [
          Text(
            '${widget.hint ?? "Value"}:  ',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Expanded(
            child: TextField(
              keyboardType: widget.keyboardType,
              style: Theme.of(context).textTheme.bodyMedium,
              controller: _controller,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
              ),
              onChanged: widget.update,
            ),
          ),
        ],
      ),
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

/// update is actually onSave
class JsonEditor extends StatefulWidget {
  const JsonEditor({
    required this.initString,
    required this.update,
    super.key,
  });

  final String initString;
  final Function(String) update;

  @override
  State<JsonEditor> createState() => _JsonEditorState();
}

class _JsonEditorState extends State<JsonEditor> {
  late CodeController controller;

  @override
  void initState() {
    super.initState();
    controller = CodeController(
      text: widget.initString,
      language: json,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 500.0,
          color: artaTheme['root']!.backgroundColor,
          child: CodeTheme(
            data: CodeThemeData(styles: artaTheme),
            child: SingleChildScrollView(
              child: CodeField(
                controller: controller,
                textStyle: TextStyle(fontSize: 13.5),
                gutterStyle: GutterStyle(
                  showLineNumbers: false,
                  // width: 60.0,
                  // textStyle: ,
                  // margin: 0.0,
                ),
              ),
            ),
          ),
        ),
        Row(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  controller.text = widget.initString;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('cancel'),
              ),
            ),
            Spacer(),
            InkWell(
              onTap: () {
                widget.update(controller.fullText);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('save'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
