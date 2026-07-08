import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart' as intl;
import 'package:live_vitalist/aliment/aliment.dart';
import 'package:live_vitalist/aliment/aliment_bank.dart';
import 'package:live_vitalist/aliment/aliment_extensions.dart';
import 'package:live_vitalist/day/day_constants.dart';
import 'package:live_vitalist/day/meal.dart';

@immutable
class Day {
  final List<Meal> meals;
  Day({List<Meal>? meals}) : meals = meals ?? DayConstants.defaultMeals;

  Map<String, dynamic> toJson() =>
      {if (meals.isNotEmpty) 'meals': meals.map((m) => m.toJson()).toList()};

  factory Day.fromJson(Map<String, dynamic> json) {
    final meals = (json['meals'] as List?)
        ?.map((e) => Meal.fromJson(e as Map<String, dynamic>))
        .toList();
    return Day(meals: meals);
  }

  Future<void> save(DateTime date) async {
    final fileName = intl.DateFormat('d_M_y').format(date);
    await StorageSolution.instance.saveJson(fileName, toJson());
  }

  Future<bool> load(DateTime date) async {
    final fileName = intl.DateFormat('d_M_y').format(date);
    final json = await StorageSolution.instance.loadJson(fileName);
    fromJson(json ?? {});
    return json != null;
  }
}

extension DaysGroupAnalysis on List<Day> {
  Day sum() {
    final merged = <String, Meal>{};

    for (final day in this) {
      for (final meal in day.meals) {
        merged.putIfAbsent(meal.name, () => Meal(name: meal.name));
        merged[meal.name]!.aliments.addAll(
          /* Creates a copy of the map aliment to solve the problem where
             the aliment was mutated when averaging multiple days. */
          meal.aliments.map(
            (e) {
              if (e is InstancedAliment) {
                return InstancedAliment.fromJson(e.toJson());
              } else /* if (e is TemporaryAliment) */ {
                return TemporaryAliment.fromJson(e.toJson());
              }
            },
          ),
        );
      }
    }

    return Day(meals: merged.values.toList());
  }

  Day average() {
    final Day sum = this.sum();

    final averagedMeals = sum.meals
        .map(
          (meal) => Meal(
            name: meal.name,
            aliments: meal.aliments
                .map((aliment) =>
                    aliment.copyWith(servingSize: aliment.servingSize / length))
                .toList(),
          ),
        )
        .toList();

    return Day(meals: averagedMeals);
  }
}

extension DayAnalysis on Day {
  List<Aliment> get aliments => meals.expand((meal) => meal.aliments).toList();

  Map<String, double> readIntake(AlimentBankState bank) =>
      aliments.summedFields(bank);

  List<Aliment> totalAliments(AlimentBankState bank) {
    final Map<String, InstancedAliment> tias = {};
    final List<TemporaryAliment> ttas = [];

    for (final Aliment sa in aliments) {
      if (sa is InstancedAliment) {
        final data = sa.readDataRef(bank);
        if (tias[sa.alimentID] == null) {
          tias[sa.alimentID] = InstancedAliment(
            alimentID: sa.alimentID,
            servingSize: 0.0,
            unit: data.unit,
          );
        }

        // totalServingSize += thisServingSize * thisUnitSize;
        tias[sa.alimentID] = tias[sa.alimentID]!.copyWith(
          servingSize: tias[sa.alimentID]!.servingSize +
              sa.servingSize * sa.readUnitSize(bank),
        );
      } else if (sa is TemporaryAliment) {
        ttas.add(sa);
      }
    }

    return [...tias.values, ...ttas];
  }

  Map<Aliment, double> topIntakeAliments(
      String nutrient, AlimentBankState bank) {
    final ta = totalAliments(bank);
    final Map<Aliment, double> result = Map.fromEntries(ta.map(
        (aliment) => MapEntry(aliment, aliment.readField(nutrient, bank, 1.0))))
      ..removeWhere((_, value) => value == 0.0);

    return Map.fromEntries(
        result.entries.toList()..sort((a, b) => b.value.compareTo(a.value)));
  }
}
