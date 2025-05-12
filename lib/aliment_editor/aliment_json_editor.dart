import 'package:flutter/material.dart';
import '../nutrient/nutrient_provider.dart';
import '../string_input.dart';

class AlimentJsonEditor extends StatelessWidget {
  const AlimentJsonEditor({
    required this.alimentJson,
    required this.nutrients,
    super.key,
  });

  final Map<String, dynamic> alimentJson;
  final NutrientState nutrients;

  @override
  Widget build(BuildContext context) {
    final Map<String, double?> expandedFields =
        Map.fromEntries(nutrients.order.map((key) => MapEntry(key, null)))
          ..removeWhere(
              (key, value) => nutrients.data[key]!.tags.contains('disabled'));

    for (MapEntry entry in alimentJson['referenceFields']?.entries ?? {}) {
      expandedFields[entry.key] = entry.value;
    }

    alimentJson['referenceFields'] = expandedFields;

    return Scaffold(
      appBar: AppBar(
        title: Text('Aliment Json Editor'),
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0).copyWith(bottom: 0.0),
        child: JsonEditor(json: alimentJson, trimNulls: true),
      ),
    );
  }
}
