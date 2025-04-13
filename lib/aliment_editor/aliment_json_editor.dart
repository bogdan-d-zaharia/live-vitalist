import 'package:flutter/material.dart';
import '../models/reference_fields_model.dart';
import '../string_input.dart';

class AlimentJsonEditor extends StatelessWidget {
  const AlimentJsonEditor({
    required this.alimentJson,
    super.key,
  });

  final Map<String, dynamic> alimentJson;

  @override
  Widget build(BuildContext context) {
    final Map<String, double?> expandedFields = NutrientsHandler.model
        .map((key, value) => MapEntry(key, null))
      ..removeWhere((key, value) => NutrientsHandler.hasTag(key, 'disabled'));

    for (MapEntry entry in alimentJson['referenceFields']?.entries ?? {}) {
      expandedFields[entry.key] = entry.value;
    }

    alimentJson['referenceFields'] = expandedFields;

    return Scaffold(
      appBar: AppBar(
        title: Text('Aliment Json Editor'),
      ),
      body: JsonEditor(json: alimentJson, trimNulls: true),
    );
  }
}
