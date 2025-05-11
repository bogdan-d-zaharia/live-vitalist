import 'aliment_bank_provider.dart';

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
        if (referenceFields.isNotEmpty) 'referenceFields': referenceFields,
        if (unitSynonyms.isNotEmpty) 'unitSynonyms': unitSynonyms,
      };

  factory AlimentData.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('unitSizes')) {
      return AlimentData(
        name: json['name'] ?? '',
        unit: json['unit'] ?? '',
        referenceSize: (json['referenceSize'] as num? ?? 0.0).toDouble(),
        referenceFields: ((json['referenceFields'] ?? {}) as Map)
            .map((k, v) => MapEntry(k, (v as num).toDouble())),
        unitSynonyms: ((json['unitSynonyms'] ?? {}) as Map)
            .map((k, v) => MapEntry(k, (v as num).toDouble())),
      );
    } else {
      final String unit = (json['unitSizes'] as Map? ?? {})
          .entries
          .firstWhere(
            (element) => element.value == 1.0,
            orElse: () => MapEntry<String, dynamic>('', 1.0),
          )
          .key as String;

      return AlimentData(
        name: json['name'] ?? '',
        unit: unit,
        referenceSize: (json['referenceSize'] as num? ?? 0.0).toDouble(),
        referenceFields: ((json['referenceFields'] ?? {}) as Map)
            .map((k, v) => MapEntry(k, (v as num).toDouble())),
        unitSynonyms: ((json['unitSizes'] ?? {}) as Map)
            .map((k, v) => MapEntry(k, (v as num).toDouble()))
          ..remove(unit),
      );
    }
  }
}

abstract class Aliment {
  Aliment({
    required this.servingSize,
    required this.unit,
  });

  double servingSize;
  String unit;

  Map<String, dynamic> toJson();
}

class TemporaryAliment extends Aliment {
  TemporaryAliment({
    required this.alimentData,
    required super.servingSize,
    required super.unit,
  });

  AlimentData alimentData;

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
  Map<String, dynamic> toJson() => {
        'alimentID': alimentID,
        'servingSize': servingSize,
        'unit': unit,
      };

  factory InstancedAliment.fromJson(Map<String, dynamic> json) =>
      InstancedAliment(
        alimentID: json['alimentID'],
        servingSize: (json['servingSize'] as num).toDouble(),
        unit: json['unit'] ?? '',
      );
}

extension AlimentDataReadUtils on Aliment {
  /// Returns the actual `AlimentData` reference.
  AlimentData readDataRef(AlimentBankState bank) {
    if (this is InstancedAliment) {
      return bank.aliments[(this as InstancedAliment).alimentID]!;
    } else /* if (this is TemporaryAliment) */ {
      return (this as TemporaryAliment).alimentData;
    }
  }

  /// Tolerable to errors,
  /// if no unit synonym found, returns 1.0 even if not the basic unit.
  double readUnitSize(AlimentBankState bank) {
    return readDataRef(bank).unitSynonyms[unit] ?? 1.0;
  }

  /// Returns a processed copy of the referencedFields,
  /// taking into account the servingSize and unit size.
  Map<String, double> readFields(AlimentBankState bank) {
    final data = readDataRef(bank);
    return data.referenceFields.map((key, value) => MapEntry(
        key, value * servingSize * readUnitSize(bank) / data.referenceSize));
  }
}

extension AlimentsAnalysis on List<Aliment> {
  Map<String, double> summedFields(AlimentBankState bank) {
    final Map<String, double> result = {};

    for (var aliment in this) {
      for (final entry in aliment.readFields(bank).entries) {
        result.update(entry.key, (v) => v + entry.value,
            ifAbsent: () => entry.value);
      }
    }

    return result;
  }
}
