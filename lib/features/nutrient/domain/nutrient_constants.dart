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
    ),

    //#region // * MACROS * //
    'protein': Nutrient(
      unit: 'g',
      lowerLimit: 100.0,
      translations: {
        'ENG': 'Protein',
      },
      tags: ['macros'],
    ),
    'carbs': Nutrient(
      unit: 'g',
      lowerLimit: 375.0,
      upperLimit: 525.0,
      translations: {
        'ENG': 'Carbohydrates',
      },
      tags: ['macros'],
    ),
    //#region // * Carb. details * //
    'sugars': Nutrient(
      unit: 'g',
      upperLimit: 56.0,
      translations: {
        'ENG': 'Sugars',
      },
      tags: ['carbDetails'],
    ),
    'fibers': Nutrient(
      unit: 'g',
      lowerLimit: 38.0,
      translations: {
        'ENG': 'Fibers',
      },
      tags: ['carbDetails'],
    ),
    //#endregion
    'fats': Nutrient(
      unit: 'g',
      lowerLimit: 83.3,
      upperLimit: 116.7,
      translations: {
        'ENG': 'Fats',
      },
      tags: ['macros'],
    ),
    //#region // * Essential fats * //
    'omega3': Nutrient(
      unit: 'g',
      lowerLimit: 2.0,
      upperLimit: 4.0,
      translations: {
        'ENG': 'Omega-3',
      },
      tags: ['essentialFats'],
    ),
    'omega6': Nutrient(
      unit: 'g',
      lowerLimit: 3.0,
      upperLimit: 7.0,
      translations: {
        'ENG': 'Omega-6',
      },
      tags: ['essentialFats'],
    ),
    //#endregion
    //#endregion
    //#region // * RISK FACTORS * //
    'sat_fats': Nutrient(
      unit: 'g',
      upperLimit: 25.0,
      translations: {
        'ENG': 'Saturated fats',
      },
      tags: ['riskFactors'],
    ),
    'cholesterol': Nutrient(
      unit: 'mg',
      lowerLimit: 100.0,
      upperLimit: 300.0,
      translations: {
        'ENG': 'Cholesterol',
      },
      tags: ['riskFactors'],
    ),
    //#endregion
    //#region // * ELECTROLYTES * //
    'sodium': Nutrient(
      unit: 'mg',
      lowerLimit: 1500.0,
      upperLimit: 2300.0,
      translations: {
        'ENG': 'Sodium',
      },
      tags: ['electrolytes'],
    ),
    'potassium': Nutrient(
      unit: 'mg',
      lowerLimit: 4700.0,
      translations: {
        'ENG': 'Potassium',
      },
      tags: ['electrolytes'],
    ),
    //#endregion
    //#region // * VITAMINS * //
    'vitamin_a': Nutrient(
      unit: 'mcg',
      lowerLimit: 1200.0,
      upperLimit: 3000.0,
      translations: {
        'ENG': 'Vitamin A (Retinol)',
      },
      tags: ['vitamins'],
    ),
    'vitamin_b1': Nutrient(
      unit: 'mg',
      lowerLimit: 1.2,
      translations: {
        'ENG': 'Vitamin B1 (Thiamin)',
      },
      tags: ['vitamins'],
    ),
    'vitamin_b2': Nutrient(
      unit: 'mg',
      lowerLimit: 1.3,
      translations: {
        'ENG': 'Vitamin B2 (Riboflavin)',
      },
      tags: ['vitamins'],
    ),
    'vitamin_b3': Nutrient(
      unit: 'mg',
      lowerLimit: 16.0,
      upperLimit: 35.0,
      translations: {
        'ENG': 'Vitamin B3 (Niacin)',
      },
      tags: ['vitamins'],
    ),
    'vitamin_b4': Nutrient(
      unit: 'mg',
      lowerLimit: 550.0,
      upperLimit: 3500.0,
      translations: {
        'ENG': 'Vitamin B4 (Choline)',
      },
      tags: ['vitamins'],
    ),
    'vitamin_b5': Nutrient(
      unit: 'mg',
      lowerLimit: 5.0,
      translations: {
        'ENG': 'Vitamin B5 (Pantothenic acid)',
      },
      tags: ['vitamins'],
    ),
    'vitamin_b6': Nutrient(
      unit: 'mg',
      lowerLimit: 1.3,
      upperLimit: 100.0,
      translations: {
        'ENG': 'Vitamin B6 (Pyridoxine)',
      },
      tags: ['vitamins'],
    ),
    'vitamin_b7': Nutrient(
      unit: 'mcg',
      lowerLimit: 30.0,
      translations: {
        'ENG': 'Vitamin B7 (Biotin)',
      },
      tags: ['vitamins'],
    ),
    'vitamin_b9': Nutrient(
      unit: 'mcg',
      lowerLimit: 400.0,
      upperLimit: 1000.0,
      translations: {
        'ENG': 'Vitamin B9 (Folate)',
      },
      tags: ['vitamins'],
    ),
    'vitamin_b12': Nutrient(
      unit: 'mcg',
      lowerLimit: 2.4,
      translations: {
        'ENG': 'Vitamin B12 (Cobalamin)',
      },
      tags: ['vitamins'],
    ),
    'vitamin_c': Nutrient(
      unit: 'mg',
      lowerLimit: 300.0,
      upperLimit: 2000.0,
      translations: {
        'ENG': 'Vitamin C (Ascorbic acid)',
      },
      tags: ['vitamins'],
    ),
    'vitamin_d2': Nutrient(
      unit: 'mcg',
      lowerLimit: 15.0,
      upperLimit: 100.0,
      translations: {
        'ENG': 'Vitamin D2 (Ergocalciferol)',
      },
      tags: ['vitamins'],
    ),
    'vitamin_d3': Nutrient(
      unit: 'mcg',
      lowerLimit: 15.0,
      upperLimit: 100.0,
      translations: {
        'ENG': 'Vitamin D3 (Cholecalciferol)',
      },
      tags: ['vitamins'],
    ),
    'vitamin_e': Nutrient(
      unit: 'mg',
      lowerLimit: 15.0,
      upperLimit: 1000.0,
      translations: {
        'ENG': 'Vitamin E (Alpha-tocopherol)',
      },
      tags: ['vitamins'],
    ),
    'vitamin_k1': Nutrient(
      unit: 'mcg',
      lowerLimit: 120.0,
      translations: {
        'ENG': 'Vitamin K1 (Phylloquinone)',
      },
      tags: ['vitamins'],
    ),
    'vitamin_k2': Nutrient(
      unit: 'mcg',
      lowerLimit: 120.0,
      translations: {
        'ENG': 'Vitamin K2 (Menaquinone)',
      },
      tags: ['vitamins'],
    ),
    //#endregion
    //#region // * MINERALS * //
    'calcium': Nutrient(
      unit: 'mg',
      lowerLimit: 1000.0,
      upperLimit: 2500.0,
      translations: {
        'ENG': 'Calcium',
      },
      tags: ['minerals'],
    ),
    'iron': Nutrient(
      unit: 'mg',
      lowerLimit: 8.0,
      upperLimit: 45.0,
      translations: {
        'ENG': 'Iron',
      },
      tags: ['minerals'],
    ),
    'magnesium': Nutrient(
      unit: 'mg',
      lowerLimit: 400.0,
      upperLimit: 600.0,
      translations: {
        'ENG': 'Magnesium',
      },
      tags: ['minerals'],
    ),
    'zinc': Nutrient(
      unit: 'mg',
      lowerLimit: 11.0,
      upperLimit: 40.0,
      translations: {
        'ENG': 'Zinc',
      },
      tags: ['minerals'],
    ),
    //#endregion
  };

  static final NutrientState defaultNutrientState = NutrientState(
    data: defaultNutrientMap,
    order: defaultNutrientMap.keys.toList(),
  );
}
