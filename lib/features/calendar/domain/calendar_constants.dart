import 'package:live_vitalist/nutrient/domain/nutrient.dart';

abstract final class CalendarConstants {
  static const double itemHeight = 80.0;
  static const double labelHeight = 26.0;

  static final helpExampleIntake = {
    Nutrient(
      translations: {'ENG': 'Calories'},
      unit: 'kcal',
      lowerLimit: 2000.0,
      upperLimit: 2500.0,
    ): 2600.0,
    Nutrient(
      translations: {'ENG': 'Fats'},
      unit: 'g',
      lowerLimit: 70.0,
      upperLimit: 100.0,
    ): 30.0,
    Nutrient(
      translations: {'ENG': 'Saturated fats'},
      unit: 'g',
      lowerLimit: 16.0,
      upperLimit: 25.0,
    ): 120.0,
  };
}
