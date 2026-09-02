import 'package:flutter/foundation.dart';

@immutable
class AlimentData {
  final Map<String, String> name;
  final String unit;
  final double referenceSize;
  final Map<String, double> referenceFields;
  final Map<String, double> unitSynonyms;

  const AlimentData({
    required this.name,
    required this.unit,
    required this.referenceSize,
    required this.referenceFields,
    required this.unitSynonyms,
  });

  Map<String, dynamic> toJson({String? languageCode}) {
    if (name.keys.length > 1) name.remove('_');
    final newName = languageCode == null
        ? name
        : name[languageCode] ?? name['en'] ?? name.values.first;
    return {
      'name': newName,
      'unit': unit,
      'referenceSize': referenceSize,
      if (referenceFields.isNotEmpty) 'referenceFields': referenceFields,
      if (unitSynonyms.isNotEmpty) 'unitSynonyms': unitSynonyms,
    };
  }

  factory AlimentData.fromJson(
    Map<String, dynamic> json, {
    String? languageCode,
  }) {
    final nameData = json['name'];
    final Map<String, String> name = switch (nameData) {
      Map _ => nameData
          .map((key, value) => MapEntry(key.toString(), value.toString())),
      String _ => {languageCode ?? '_': nameData},
      _ => {'_': ''},
    };

    late final String unit;
    final referenceSize = (json['referenceSize'] as num? ?? 0.0).toDouble();
    final Map<String, double> referenceFields =
        ((json['referenceFields'] ?? {}) as Map)
            .map((k, v) => MapEntry(k, (v as num).toDouble()));
    late final Map<String, double> unitSynonyms;

    if (!json.containsKey('unitSizes')) {
      unit = json['unit'] ?? '';
      unitSynonyms = ((json['unitSynonyms'] ?? {}) as Map)
          .map((k, v) => MapEntry(k, (v as num).toDouble()));
    } else {
      unit = (json['unitSizes'] as Map? ?? {})
          .entries
          .firstWhere(
            (element) => element.value == 1.0,
            orElse: () => MapEntry<String, dynamic>('', 1.0),
          )
          .key as String;
      unitSynonyms = ((json['unitSizes'] ?? {}) as Map)
          .map((k, v) => MapEntry(k, (v as num).toDouble()))
        ..remove(unit);
    }

    return AlimentData(
      name: name,
      unit: unit,
      referenceSize: referenceSize,
      referenceFields: referenceFields,
      unitSynonyms: unitSynonyms,
    );
  }

  AlimentData copyWith({
    Map<String, String>? name,
    String? unit,
    double? referenceSize,
    Map<String, double>? referenceFields,
    Map<String, double>? unitSynonyms,
  }) {
    return AlimentData(
      name: name ?? this.name,
      unit: unit ?? this.unit,
      referenceSize: referenceSize ?? this.referenceSize,
      referenceFields: referenceFields ?? this.referenceFields,
      unitSynonyms: unitSynonyms ?? this.unitSynonyms,
    );
  }

  static const empty = AlimentData(
    name: {'_': ''},
    unit: 'g',
    referenceSize: 100.0,
    referenceFields: {},
    unitSynonyms: {},
  );
}
