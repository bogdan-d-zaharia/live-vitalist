import 'package:flutter/foundation.dart';
import 'package:live_vitalist/features/day/domain/day_constants.dart';
import 'package:live_vitalist/features/day/domain/meal.dart';

@immutable
class Day {
  final List<Meal> meals;
  final String? nutrientConfigId;

  Day({List<Meal>? meals, this.nutrientConfigId})
      : meals = meals ?? DayConstants.defaultMeals;

  Day copyWith({List<Meal>? meals}) => Day(
        meals: meals ?? this.meals,
        nutrientConfigId: nutrientConfigId,
      );

  Map<String, dynamic> toJson() => {
        if (meals.isNotEmpty) 'meals': meals.map((m) => m.toJson()).toList(),
        'nutrientConfigId': nutrientConfigId,
      };

  factory Day.fromJson(Map<String, dynamic> json) {
    final meals = (json['meals'] as List?)
        ?.map((e) => Meal.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
    final nutrientConfigId = switch (json['nutrientConfigId']) {
      String id => id,
      _ => null,
    };
    return Day(meals: meals, nutrientConfigId: nutrientConfigId);
  }
}
