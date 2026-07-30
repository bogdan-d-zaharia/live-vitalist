import 'package:live_vitalist/features/nutrient/data/nutrient_provider.dart';

import 'nutrient.dart';

abstract final class NutrientConstants {
  static const Map<String, Nutrient> defaultNutrientMap = {
    /* Main */
    'kcals': Nutrient(
      unit: 'kcal',
      lowerLimit: 3300.0,
      translations: {
        'ENG': 'Calories',
      },
      tags: ['starred'],
    ),
    'protein': Nutrient(
      unit: 'g',
      lowerLimit: 100.0,
      translations: {
        'ENG': 'Protein',
      },
    ),
    'fats': Nutrient(
      unit: 'g',
      lowerLimit: 83.3,
      upperLimit: 116.7,
      translations: {
        'ENG': 'Fats',
      },
    ),
    'satFats': Nutrient(
      unit: 'g',
      upperLimit: 25.0,
      translations: {
        'ENG': 'Saturated fats',
      },
    ),
    'carbs': Nutrient(
      unit: 'g',
      lowerLimit: 375.0,
      upperLimit: 525.0,
      translations: {
        'ENG': 'Carbohydrates',
      },
    ),
    'sugars': Nutrient(
      unit: 'g',
      upperLimit: 56.0,
      translations: {
        'ENG': 'Sugars',
      },
      tags: ['disabled'],
    ),
    'fibers': Nutrient(
      unit: 'g',
      lowerLimit: 38.0,
      translations: {
        'ENG': 'Fibers',
      },
      tags: ['disabled'],
    ),

    /* Important */
    'cholesterol': Nutrient(
      unit: 'mg',
      lowerLimit: 100.0,
      upperLimit: 300.0,
      translations: {
        'ENG': 'Cholesterol',
      },
    ),
    'omega3': Nutrient(
      unit: 'g',
      lowerLimit: 2.0,
      upperLimit: 4.0,
      translations: {
        'ENG': 'Omega-3',
      },
      tags: ['disabled'],
    ),
    'omega6': Nutrient(
      unit: 'g',
      lowerLimit: 3.0,
      upperLimit: 7.0,
      translations: {
        'ENG': 'Omega-6',
      },
      tags: ['disabled'],
    ),

    /* Vitamins */
    'vitaminA': Nutrient(
      unit: 'mcg',
      lowerLimit: 1200.0,
      upperLimit: 3000.0,
      translations: {
        'ENG': 'Vitamin A (Retinol)',
      },
      tags: ['disabled'],
    ),
    'vitaminB1': Nutrient(
      unit: 'mg',
      lowerLimit: 1.2,
      translations: {
        'ENG': 'Vitamin B1 (Thiamin)',
      },
      tags: ['disabled'],
    ),
    'vitaminB2': Nutrient(
      unit: 'mg',
      lowerLimit: 1.3,
      translations: {
        'ENG': 'Vitamin B2 (Riboflavin)',
      },
      tags: ['disabled'],
    ),
    'vitaminB3': Nutrient(
      unit: 'mg',
      lowerLimit: 16.0,
      upperLimit: 35.0,
      translations: {
        'ENG': 'Vitamin B3 (Niacin)',
      },
      tags: ['disabled'],
    ),
    'vitaminB4': Nutrient(
      unit: 'mg',
      lowerLimit: 550.0,
      upperLimit: 3500.0,
      translations: {
        'ENG': 'Vitamin B4 (Choline)',
      },
      tags: ['disabled'],
    ),
    'vitaminB5': Nutrient(
      unit: 'mg',
      lowerLimit: 5.0,
      translations: {
        'ENG': 'Vitamin B5 (Pantothenic acid)',
      },
      tags: ['disabled'],
    ),
    'vitaminB6': Nutrient(
      unit: 'mg',
      lowerLimit: 1.3,
      upperLimit: 100.0,
      translations: {
        'ENG': 'Vitamin B6 (Pyridoxine)',
      },
      tags: ['disabled'],
    ),
    'vitaminB7': Nutrient(
      unit: 'mcg',
      lowerLimit: 30.0,
      translations: {
        'ENG': 'Vitamin B7 (Biotin)',
      },
      tags: ['disabled'],
    ),
    'vitaminB9': Nutrient(
      unit: 'mcg',
      lowerLimit: 400.0,
      upperLimit: 1000.0,
      translations: {
        'ENG': 'Vitamin B9 (Folate)',
      },
      tags: ['disabled'],
    ),
    'vitaminB12': Nutrient(
      unit: 'mcg',
      lowerLimit: 2.4,
      translations: {
        'ENG': 'Vitamin B12 (Cobalamin)',
      },
      tags: ['disabled'],
    ),
    'vitaminC': Nutrient(
      unit: 'mg',
      lowerLimit: 300.0,
      upperLimit: 2000.0,
      translations: {
        'ENG': 'Vitamin C (Ascorbic acid)',
      },
      tags: ['disabled'],
    ),
    'vitaminD2': Nutrient(
      unit: 'mcg',
      lowerLimit: 15.0,
      upperLimit: 100.0,
      translations: {
        'ENG': 'Vitamin D2 (Ergocalciferol)',
      },
      tags: ['disabled'],
    ),
    'vitaminD3': Nutrient(
      unit: 'mcg',
      lowerLimit: 15.0,
      upperLimit: 100.0,
      translations: {
        'ENG': 'Vitamin D3 (Cholecalciferol)',
      },
      tags: ['disabled'],
    ),
    'vitaminE': Nutrient(
      unit: 'mg',
      lowerLimit: 15.0,
      upperLimit: 1000.0,
      translations: {
        'ENG': 'Vitamin E (Alpha-tocopherol)',
      },
      tags: ['disabled'],
    ),
    'vitaminK1': Nutrient(
      unit: 'mcg',
      lowerLimit: 120.0,
      translations: {
        'ENG': 'Vitamin K1 (Phylloquinone)',
      },
      tags: ['disabled'],
    ),
    'vitaminK2': Nutrient(
      unit: 'mcg',
      lowerLimit: 120.0,
      translations: {
        'ENG': 'Vitamin K2 (Menaquinone)',
      },
      tags: ['disabled'],
    ),

    /* Minerals */
    'calcium': Nutrient(
      unit: 'mg',
      lowerLimit: 1000.0,
      upperLimit: 2500.0,
      translations: {
        'ENG': 'Calcium',
      },
      tags: ['disabled'],
    ),
    'sodium': Nutrient(
      unit: 'mg',
      lowerLimit: 1500.0,
      upperLimit: 2300.0,
      translations: {
        'ENG': 'Sodium',
      },
      tags: ['disabled'],
    ),
    'potassium': Nutrient(
      unit: 'mg',
      lowerLimit: 4700.0,
      translations: {
        'ENG': 'Potassium',
      },
      tags: ['disabled'],
    ),
    'iron': Nutrient(
      unit: 'mg',
      lowerLimit: 8.0,
      upperLimit: 45.0,
      translations: {
        'ENG': 'Iron',
      },
      tags: ['disabled'],
    ),
    'zinc': Nutrient(
      unit: 'mg',
      lowerLimit: 11.0,
      upperLimit: 40.0,
      translations: {
        'ENG': 'Zinc',
      },
      tags: ['disabled'],
    ),
    'magnesium': Nutrient(
      unit: 'mg',
      lowerLimit: 400.0,
      upperLimit: 600.0,
      translations: {
        'ENG': 'Magnesium',
      },
      tags: ['disabled'],
    ),
  };

  static final NutrientState defaultNutrientState = NutrientState(
    data: defaultNutrientMap,
    order: defaultNutrientMap.keys.toList(),
  );
}
