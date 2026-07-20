import 'package:flutter/foundation.dart';
import 'package:live_vitalist/features/day/domain/day_constants.dart';
import 'package:live_vitalist/features/day/domain/meal.dart';

@immutable
class Day {
  final List<Meal> meals;
  Day({List<Meal>? meals}) : meals = meals ?? DayConstants.defaultMeals;

  Map<String, dynamic> toJson() =>
      {if (meals.isNotEmpty) 'meals': meals.map((m) => m.toJson()).toList()};

  factory Day.fromJson(Map<String, dynamic> json) {
    final meals = (json['meals'] as List?)
        ?.map((e) => Meal.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
    return Day(meals: meals);
  }
}
