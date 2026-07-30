import 'package:flutter/material.dart';
import 'package:live_vitalist/features/aliment/domain/aliment_data.dart';
import 'package:live_vitalist/features/aliment_editor/aliment_json_editor.dart';

class JsonEditorButton extends StatelessWidget {
  final AlimentData data;
  final void Function(AlimentData) onResult;

  const JsonEditorButton({
    required this.data,
    required this.onResult,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        final newData = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AlimentJsonEditor(initialData: data),
          ),
        );
        if (newData != null) onResult(newData);
      },
      icon: const Icon(Icons.code_rounded),
    );
  }
}
