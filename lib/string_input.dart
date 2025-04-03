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
  final InputDecoration? decoration;

  const StringInput({
    super.key,
    this.hint,
    this.initString,
    this.update,
    this.width,
    this.keyboardType,
    this.decoration,
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
              decoration: widget.decoration ??
                  const InputDecoration(
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
          height: 400.0,
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

//TODO: Perhaps handle null getValue, so that there might be fields where it is
// for sure 0.0 and fields where it is assumed that is not specified.
class NumberInput extends StatefulWidget {
  const NumberInput({
    required this.getValue,
    required this.setValue,
    this.showHandles = true,
    super.key,
  });

  final double Function() getValue;
  final Function(double) setValue;
  final bool showHandles;

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
      color: color ?? Colors.grey[200],
    );
  }

  @override
  Widget build(BuildContext context) {
    _controller.text = number.toString();
    final double height = 42.0;

    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height / 2.0),
        color: Colors.white,
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
            child: TextField(
              expands: true,
              maxLines: null,
              minLines: null,
              // style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.center,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              controller: _controller,
              decoration: InputDecoration(border: InputBorder.none),
              onChanged: (value) {
                final double? v = double.tryParse(value);
                if (v != null && v.isFinite) number = v;
              },
              onEditingComplete: () => setState(() {}),
            ),
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
