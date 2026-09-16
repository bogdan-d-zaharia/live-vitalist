import 'package:flutter/foundation.dart';

@immutable
class NutrientConfigHeader {
  final String id;
  final String? name;

  const NutrientConfigHeader({required this.id, this.name});

  factory NutrientConfigHeader.fromJson(Map<String, dynamic> json) =>
      NutrientConfigHeader(
          id: json['id'] as String, name: json['name'] as String?);

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
