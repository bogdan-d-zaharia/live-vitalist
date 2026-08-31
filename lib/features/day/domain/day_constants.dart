import 'package:live_vitalist/features/day/domain/meal.dart';

class DayConstants {
  static List<Meal> get defaultMeals => [
        Meal(key: 'breakfast'),
        Meal(key: 'lunch'),
        Meal(key: 'dinner'),
      ];
}
