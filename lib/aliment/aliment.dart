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
    return AlimentData(
      name: json['name'],
      unit: json['unit'],
      referenceSize: (json['referenceSize'] as num).toDouble(),
      referenceFields: ((json['referenceFields'] ?? {}) as Map<String, dynamic>)
          .map((k, v) => MapEntry(k, (v as num).toDouble())),
      unitSynonyms: ((json['unitSynonyms'] ?? {}) as Map<String, dynamic>)
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
        unit: json['unit'],
      );
}
