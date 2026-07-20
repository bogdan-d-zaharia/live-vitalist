import 'package:flutter/foundation.dart';
import 'package:live_vitalist/features/aliment/domain/aliment.dart';

// TODO: Ar trebui sa foloseasca `@freezed` in loc de `@immutable`
// pentru ca si lista de alimente sa nu fie modificabila

@immutable
class Meal {
  Meal({
    required this.name,
    List<Aliment>? aliments,
  }) : aliments = aliments ?? [];

  final String name;
  final List<Aliment> aliments;

  Map<String, dynamic> toJson() => {
        'name': name,
        'aliments': aliments.map((a) => a.toJson()).toList(),
      };

  factory Meal.fromJson(Map<String, dynamic> json) => Meal(
        name: json['name'],
        aliments: ((json['aliments'] ?? []) as List<dynamic>).map((e) {
          final el = (e as Map).cast<String, dynamic>();
          return el.containsKey('alimentID')
              ? InstancedAliment.fromJson(el)
              : TemporaryAliment.fromJson(el);
        }).toList(),
      );
}
