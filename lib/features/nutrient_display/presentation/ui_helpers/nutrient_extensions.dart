import 'package:live_vitalist/features/nutrient/domain/nutrient.dart';
import 'package:live_vitalist/features/nutrient_display/domain/intake.dart';
import 'package:live_vitalist/l10n/app_localizations.dart';

extension NutrientExtensions on Nutrient {
  Intake toIntake(String label, double amount) {
    return Intake(label, amount, lowerLimit, upperLimit, unit);
  }

  String resolveNutrientLabel({
    required AppLocalizations localization,
    required String nutrientKey,
    required String localeCode,
  }) {
    return translationOverrides[localeCode] ??
        localization.defaultNutrientLabel(nutrientKey) ??
        translationOverrides['en'] ??
        translationOverrides.values.firstOrNull ??
        nutrientKey;
  }
}

extension NutrientLocalizations on AppLocalizations {
  String? defaultNutrientLabel(String nutrientKey) {
    return switch (nutrientKey) {
      'kcals' => nutrientKcals,
      'protein' => nutrientProtein,
      'carbs' => nutrientCarbs,
      'sugars' => nutrientSugars,
      'fibers' => nutrientFibers,
      'fats' => nutrientFats,
      'omega3' => nutrientOmega3,
      'omega6' => nutrientOmega6,
      'sat_fats' => nutrientSaturatedFats,
      'cholesterol' => nutrientCholesterol,
      'sodium' => nutrientSodium,
      'potassium' => nutrientPotassium,
      'vitamin_a' => nutrientVitaminA,
      'vitamin_b1' => nutrientVitaminB1,
      'vitamin_b2' => nutrientVitaminB2,
      'vitamin_b3' => nutrientVitaminB3,
      'vitamin_b4' => nutrientVitaminB4,
      'vitamin_b5' => nutrientVitaminB5,
      'vitamin_b6' => nutrientVitaminB6,
      'vitamin_b7' => nutrientVitaminB7,
      'vitamin_b9' => nutrientVitaminB9,
      'vitamin_b12' => nutrientVitaminB12,
      'vitamin_c' => nutrientVitaminC,
      'vitamin_d2' => nutrientVitaminD2,
      'vitamin_d3' => nutrientVitaminD3,
      'vitamin_e' => nutrientVitaminE,
      'vitamin_k1' => nutrientVitaminK1,
      'vitamin_k2' => nutrientVitaminK2,
      'calcium' => nutrientCalcium,
      'iron' => nutrientIron,
      'magnesium' => nutrientMagnesium,
      'zinc' => nutrientZinc,
      _ => null,
    };
  }
}
