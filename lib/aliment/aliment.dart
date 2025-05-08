import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../file_handler.dart';
import '../json_handler.dart';

// --- Core Data Model --- //

class AlimentData {
  AlimentData({
    required this.name,
    required this.unit,
    required this.referenceSize,
    required this.referenceFields,
    required this.unitSynonyms,
  });

  String name;
  String unit;
  double referenceSize;
  Map<String, double> referenceFields;
  Map<String, double> unitSynonyms;

  Map<String, dynamic> toJson() => {
        'name': name,
        'unit': unit,
        'referenceSize': referenceSize,
        'referenceFields': referenceFields,
        'unitSynonyms': unitSynonyms,
      };

  factory AlimentData.fromJson(Map<String, dynamic> json) {
    return AlimentData(
      name: json['name'],
      unit: json['unit'],
      referenceSize: (json['referenceSize'] as num).toDouble(),
      referenceFields: (json['referenceFields'] as Map<String, dynamic>)
          .map((k, v) => MapEntry(k, (v as num).toDouble())),
      unitSynonyms: (json['unitSynonyms'] as Map<String, dynamic>)
          .map((k, v) => MapEntry(k, (v as num).toDouble())),
    );
  }
}

abstract class Aliment {
  Aliment({
    required this.servingSize,
    required this.unit,
  });

  double servingSize;
  String unit;

  AlimentData get getAliment;

  Map<String, dynamic> toJson();
}

extension AlimentUtils on Aliment {
  /// Tolerant to errors,
  /// should throw an error if not in synonyms and not the default unit.
  double getUnitSize() {
    return getAliment.unitSynonyms[unit] ?? 1.0;
  }
}

class TemporaryAliment extends Aliment {
  TemporaryAliment({
    required this.alimentData,
    required super.servingSize,
    required super.unit,
  });

  AlimentData alimentData;

  @override
  AlimentData get getAliment => alimentData;

  @override
  Map<String, dynamic> toJson() => {
        'alimentData': alimentData.toJson(),
        'servingSize': servingSize,
        'unit': unit,
      };

  factory TemporaryAliment.fromJson(Map<String, dynamic> json) =>
      TemporaryAliment(
        alimentData: AlimentData.fromJson(json['alimentData']),
        servingSize: (json['servingSize'] as num).toDouble(),
        unit: json['unit'],
      );
}

class InstancedAliment extends Aliment {
  InstancedAliment({
    required this.alimentID,
    required super.servingSize,
    required super.unit,
  });

  String alimentID;

  @override
  AlimentData get getAliment =>
      AlimentBank.instance.read().aliments[alimentID]!;

  @override
  Map<String, dynamic> toJson() => {
        'alimentID': alimentID,
        'servingSize': servingSize,
        'unit': unit,
      };

  factory InstancedAliment.fromJson(Map<String, dynamic> json) =>
      InstancedAliment(
        alimentID: json['alimentID'],
        servingSize: (json['servingSize'] as num).toDouble(),
        unit: json['unit'],
      );
}
