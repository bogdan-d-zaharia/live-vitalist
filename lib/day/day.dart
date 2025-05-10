import 'package:intl/intl.dart' as intl;

import '../aliment/aliment.dart';
import '../file_handler.dart';

class Meal {
  Meal({required this.name, List<Aliment>? aliments})
      : aliments = aliments ?? [];

  final String name;
  final List<Aliment> aliments;

  Map<String, dynamic> toJson() => {
        'name': name,
        'aliments': aliments.map((a) => a.toJson()).toList(),
      };

  factory Meal.fromJson(Map<String, dynamic> json) => Meal(
        name: json['name'],
        aliments: (json['aliments'] as List<dynamic>)
            .map((e) => (e as Map<String, dynamic>).containsKey('alimentID')
                ? InstancedAliment.fromJson(e)
                : TemporaryAliment.fromJson(e))
            .toList(),
      );
}

class Day {
  Day({List<Meal>? meals})
      : meals = meals ??
            [
              Meal(name: 'breakfast'),
              Meal(name: 'lunch'),
              Meal(name: 'dinner'),
            ];

  final List<Meal> meals;

  Map<String, dynamic> toJson() =>
      {if (meals.isNotEmpty) 'meals': meals.map((m) => m.toJson()).toList()};

  void fromJson(Map<String, dynamic> json) {
    if (json['meals'] != null) {
      meals
        ..clear()
        ..addAll((json['meals'] as List<dynamic>)
            .map((e) => Meal.fromJson(e as Map<String, dynamic>)));
    }
  }

  Future<void> save(DateTime date) async {
    final fileName = intl.DateFormat('d_M_y').format(date);
    await StorageHandler.saveJson(fileName, toJson());
  }

  Future<bool> load(DateTime date) async {
    final fileName = intl.DateFormat('d_M_y').format(date);
    final json = await StorageHandler.loadJson(fileName);
    fromJson(json ?? {});
    return json != null;
  }

  static Day sumDays(List<Day> days) {
    final merged = <String, Meal>{};

    for (final day in days) {
      for (final meal in day.meals) {
        merged.putIfAbsent(meal.name, () => Meal(name: meal.name));
        merged[meal.name]!.aliments.addAll(meal.aliments);
      }
    }

    return Day(meals: merged.values.toList());
  }
}
