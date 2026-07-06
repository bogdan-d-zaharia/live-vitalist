import 'dart:convert';

import 'package:live_vitalist/aliment/aliment_data.dart';
import 'package:live_vitalist/nutrient/nutrient_provider.dart';
import 'package:live_vitalist/json_handler.dart';

extension AlimentJsonExtension on AlimentData {
  Map<String, dynamic> toExpandedJson(NutrientState nutrients) {
    final alimentJson = toJson();
    final Map<String, double?> expandedFields =
        Map.fromEntries(nutrients.order.map((key) => MapEntry(key, null)))
          ..removeWhere(
              (key, value) => nutrients.data[key]!.tags.contains('disabled'));

    for (MapEntry entry in alimentJson['referenceFields']?.entries ?? {}) {
      expandedFields[entry.key] = entry.value;
    }

    alimentJson['referenceFields'] = expandedFields;
    alimentJson['unitSynonyms'] ??= {};

    return alimentJson;
  }

  String toExpandedWithUnitsJson(NutrientState nutrients) {
    final Map<String, dynamic> expandedJson = toExpandedJson(nutrients);

    final buffer = StringBuffer();
    buffer.writeln('{');

    void writeField(String key, dynamic value,
        {String? comment, int indent = 2}) {
      final ind = ' ' * indent;
      final valStr = switch (value is String) {
        true => value == 'null' ? null : '"$value"',
        false => value.toString(),
      };
      final commentStr = comment != null ? ' // $comment' : '';
      buffer.writeln('$ind"$key": $valStr,$commentStr');
    }

    writeField('name', expandedJson['name']);
    writeField('unit', expandedJson['unit']);
    writeField('referenceSize', expandedJson['referenceSize']);

    // referenceFields
    buffer.writeln('  "referenceFields": {');
    final refFields = expandedJson['referenceFields'] as Map<String, dynamic>;
    for (final entry in refFields.entries) {
      final unit = nutrients.data[entry.key]?.unit ?? '';
      writeField(entry.key, entry.value ?? 'null', comment: unit, indent: 4);
    }
    buffer.writeln('  },');

    // unitSynonyms
    buffer.writeln('  "unitSynonyms": {');
    final unitSynonyms = expandedJson['unitSynonyms'] as Map;
    for (final entry in unitSynonyms.entries) {
      writeField(entry.key as String, entry.value, indent: 4);
    }
    buffer.writeln('  } // eg. "portion": 60');

    buffer.write('}');
    return buffer.toString();
  }

  // TODO: Fix, not depending on `AlimentData`.
  Map<String, dynamic> fromExpandedJsonWithCommentsToJsonMap(String input) {
    // Step 1: Remove inline comments
    String cleaned = input.replaceAllMapped(
      RegExp(r'//.*$', multiLine: true),
      (_) => '',
    );

    // Step 2: Remove trailing commas before closing braces/brackets
    cleaned = cleaned.replaceAllMapped(
      RegExp(r',\s*(?=[}\]])'), // match comma followed by } or ]
      (_) => '',
    );

    // Step 3: Decode to JSON
    try {
      return JsonHandler.processJson(jsonDecode(cleaned), removeNulls: true);
    } catch (e) {
      throw FormatException('Invalid JSON after cleaning: $e');
    }
  }
}
