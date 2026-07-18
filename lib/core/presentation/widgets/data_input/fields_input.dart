import 'package:flutter/material.dart';

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
