import 'package:flutter/material.dart';
import 'package:live_vitalist/core/theme/custom_icons.dart';
import 'package:live_vitalist/features/onboarding/domain/options/nutrients_option.dart';
import 'package:live_vitalist/features/onboarding/presentation/widgets/option_card.dart';

class NutrientsOptionDrawer extends StatelessWidget {
  final NutrientsOption nutrient;
  final bool isSelected;
  final VoidCallback onTap;

  const NutrientsOptionDrawer({
    super.key,
    required this.nutrient,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final icon = switch (nutrient) {
      NutrientsOption.macros => CustomIcons.macros,
      NutrientsOption.riskFactors => CustomIcons.riskFactors,
      NutrientsOption.electrolytes => CustomIcons.electrolytes,
      NutrientsOption.vitamins => CustomIcons.vitamins,
      NutrientsOption.minerals => CustomIcons.minerals,
      // _ => Icons.account_balance_rounded,
    };
    final title = switch (nutrient) {
      NutrientsOption.macros => "Macros",
      NutrientsOption.riskFactors => "Risk Factors",
      NutrientsOption.electrolytes => "Electrolytes",
      NutrientsOption.vitamins => "Vitamins",
      NutrientsOption.minerals => "Minerals",
    };
    final footer = switch (nutrient) {
      NutrientsOption.macros => "Protein · Carbs · Fats",
      NutrientsOption.riskFactors => "Sat. Fats · Cholesterol",
      NutrientsOption.electrolytes => "Sodium · Potassium",
      NutrientsOption.vitamins => "A · B-Complex · C · D · E · K",
      NutrientsOption.minerals => "Iron · Calcium · Magnesium · Zinc",
    };

    return OptionCard(
      icon: icon,
      title: title,
      footer: footer,
      isSelected: isSelected,
      onTap: onTap,
    );
  }
}
