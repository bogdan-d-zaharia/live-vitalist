import 'package:flutter/foundation.dart';

@immutable
class Nutrient {
  final Map<String, String> translationOverrides;
  final String unit;
  final double? lowerLimit;
  final double? upperLimit;
  final List<String> tags;

  const Nutrient({
    this.translationOverrides = const {},
    required this.unit,
    this.lowerLimit,
    this.upperLimit,
    this.tags = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'unit': unit,
      'lowerLimit': lowerLimit,
      'upperLimit': upperLimit,
      if (translationOverrides.isNotEmpty)
        'translationOverrides': translationOverrides,
      if (tags.isNotEmpty) 'tags': tags,
    };
  }

  factory Nutrient.fromJson(Map<String, dynamic> json) {
    return Nutrient(
      unit: json['unit'],
      lowerLimit: (json['lowerLimit'] as num?)?.toDouble(),
      upperLimit: (json['upperLimit'] as num?)?.toDouble(),
      translationOverrides:
          Map<String, String>.from(json['translationOverrides'] ?? {}),
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  Nutrient copyWith({
    Map<String, String>? translationOverrides,
    String? unit,
    double? lowerLimit,
    double? upperLimit,
    List<String>? tags,
  }) {
    return Nutrient(
      translationOverrides:
          translationOverrides ?? Map.from(this.translationOverrides),
      unit: unit ?? this.unit,
      lowerLimit: lowerLimit ?? this.lowerLimit,
      upperLimit: upperLimit ?? this.upperLimit,
      tags: tags ?? List.from(this.tags),
    );
  }
}
