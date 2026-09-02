part of 'aliment.dart';

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
        alimentData: AlimentData.fromJson(
            (json['alimentData'] as Map).cast<String, dynamic>()),
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
