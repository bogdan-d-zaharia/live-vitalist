import 'package:flutter/foundation.dart';
import 'package:live_vitalist/aliment/aliment_data.dart';
import 'aliment_bank.dart';

@immutable
abstract class Aliment {
  final double servingSize;
  final String unit;

  const Aliment({
    required this.servingSize,
    required this.unit,
  });

  Map<String, dynamic> toJson();
  AlimentData readDataRef(AlimentBankState bank);
  Aliment copyWith({double? servingSize, String? unit});
}

@immutable
class TemporaryAliment extends Aliment {
  final AlimentData alimentData;

  const TemporaryAliment({
    required this.alimentData,
    required super.servingSize,
    required super.unit,
  });

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
        unit: json['unit'] ?? '',
      );

  @override
  AlimentData readDataRef(AlimentBankState bank) {
    return alimentData;
  }

  @override
  TemporaryAliment copyWith({
    AlimentData? alimentData,
    double? servingSize,
    String? unit,
  }) {
    return TemporaryAliment(
      alimentData: alimentData ?? this.alimentData,
      servingSize: servingSize ?? this.servingSize,
      unit: unit ?? this.unit,
    );
  }

  static const empty = TemporaryAliment(
    alimentData: AlimentData(
      name: '',
      unit: 'portion',
      referenceSize: 1.0,
      referenceFields: {},
      unitSynonyms: {},
    ),
    servingSize: 1.0,
    unit: 'portion',
  );
}

@immutable
class InstancedAliment extends Aliment {
  final String alimentID;

  const InstancedAliment({
    required this.alimentID,
    required super.servingSize,
    required super.unit,
  });

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

  @override
  AlimentData readDataRef(AlimentBankState bank) {
    return bank.aliments[alimentID]!;
  }

  @override
  InstancedAliment copyWith({
    String? alimentID,
    double? servingSize,
    String? unit,
  }) {
    return InstancedAliment(
      alimentID: alimentID ?? this.alimentID,
      servingSize: servingSize ?? this.servingSize,
      unit: unit ?? this.unit,
    );
  }

  static const empty =
      InstancedAliment(alimentID: '', servingSize: 1.0, unit: 'g');
}
