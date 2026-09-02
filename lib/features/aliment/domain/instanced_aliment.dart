part of 'aliment.dart';

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
