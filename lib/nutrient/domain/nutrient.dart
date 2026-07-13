import 'package:flutter/foundation.dart';

@immutable
class Nutrient {
  final Map<String, String> translations;
  final String unit;
  final double? lowerLimit;
  final double? upperLimit;
  final List<String> tags;

  const Nutrient({
    required this.translations,
    required this.unit,
    this.lowerLimit,
    this.upperLimit,
    List<String>? tags,
  }) : tags = tags ?? const [];

  Map<String, dynamic> toJson() {
    return {
      'unit': unit,
      'lowerLimit': lowerLimit,
      'upperLimit': upperLimit,
      'translations': translations,
      if (tags.isNotEmpty) 'tags': tags,
    };
  }

  factory Nutrient.fromJson(Map<String, dynamic> json) {
    return Nutrient(
      unit: json['unit'],
      lowerLimit: (json['lowerLimit'] as num?)?.toDouble(),
      upperLimit: (json['upperLimit'] as num?)?.toDouble(),
      translations: Map<String, String>.from(json['translations'] ?? {}),
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  Nutrient copyWith({
    Map<String, String>? translations,
    String? unit,
    double? lowerLimit,
    double? upperLimit,
    List<String>? tags,
  }) {
    return Nutrient(
      translations: translations ?? Map.from(this.translations),
      unit: unit ?? this.unit,
      lowerLimit: lowerLimit ?? this.lowerLimit,
      upperLimit: upperLimit ?? this.upperLimit,
      tags: tags ?? List.from(this.tags),
    );
  }
}
