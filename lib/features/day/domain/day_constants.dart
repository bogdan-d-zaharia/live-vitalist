import 'package:live_vitalist/features/day/domain/meal.dart';

class DayConstants {
  static List<Meal> get defaultMeals => [
        Meal(name: 'breakfast'),
        Meal(name: 'lunch'),
        Meal(name: 'dinner'),
      ];
}
