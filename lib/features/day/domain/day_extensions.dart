import 'package:live_vitalist/features/aliment/domain/aliment_extensions.dart';
import 'package:live_vitalist/features/aliment/data/aliment_bank.dart';
import 'package:live_vitalist/features/aliment/domain/aliment.dart';
import 'package:live_vitalist/features/day/domain/day.dart';
import 'package:live_vitalist/features/day/domain/meal.dart';

extension DaysGroupAnalysis on List<Day> {
  Day sum() {
    final merged = <String, Meal>{};

    for (final day in this) {
      for (final meal in day.meals) {
        merged.putIfAbsent(meal.name, () => Meal(name: meal.name));
        /* Creates a copy of the map aliment to solve the problem where
             the aliment was mutated when averaging multiple days. */
        merged[meal.name]!
            .aliments
            .addAll(meal.aliments.map((e) => e.copyWith()));
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

extension AlimentFlattening on Aliment {
  dynamic getKey() {
    return switch (this) {
      InstancedAliment a => a.alimentID,
      TemporaryAliment b => b, // The reference
    };
  }

  double basicServingSize(AlimentBankState bank) {
    return servingSize * readUnitSize(bank);
  }

  Aliment withBasicUnit(AlimentBankState bank) {
    return copyWith(
      unit: readDataRef(bank).unit,
      servingSize: basicServingSize(bank),
    );
  }

  Aliment addToAliment(Aliment current, AlimentBankState bank) {
    return current.copyWith(
      servingSize: current.servingSize + basicServingSize(bank),
    );
  }
}

extension DayAnalysis on Day {
  List<Aliment> get aliments => meals.expand((meal) => meal.aliments).toList();

  Map<String, double> readIntake(AlimentBankState bank) =>
      aliments.summedFields(bank);

  List<Aliment> totalAliments(AlimentBankState bank) {
    final Map<dynamic, Aliment> total = {}; // Working in basic unit
    for (final aliment in aliments) {
      total.update(
        aliment.getKey(),
        (current) => aliment.addToAliment(current, bank),
        ifAbsent: () => aliment.withBasicUnit(bank),
      );
    }
    return total.values.toList();
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
