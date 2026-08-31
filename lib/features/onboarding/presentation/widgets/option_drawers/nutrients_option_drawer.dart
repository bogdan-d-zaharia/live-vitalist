import 'package:flutter/material.dart';
import 'package:live_vitalist/core/theme/custom_icons.dart';
import 'package:live_vitalist/features/onboarding/domain/options/nutrients_option.dart';
import 'package:live_vitalist/features/onboarding/presentation/widgets/option_card.dart';
import 'package:live_vitalist/l10n/app_localizations.dart';

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
    final l = AppLocalizations.of(context);
    final icon = switch (nutrient) {
      NutrientsOption.macros => CustomIcons.macros,
      NutrientsOption.riskFactors => CustomIcons.riskFactors,
      NutrientsOption.electrolytes => CustomIcons.electrolytes,
      NutrientsOption.vitamins => CustomIcons.vitamins,
      NutrientsOption.minerals => CustomIcons.minerals,
      // _ => Icons.account_balance_rounded,
    };
    final title = switch (nutrient) {
      NutrientsOption.macros => l.onboardingNutrientsOptionMacrosTitle,
      NutrientsOption.riskFactors => l.onboardingNutrientsOptionRiskFactorsTitle,
      NutrientsOption.electrolytes => l.onboardingNutrientsOptionElectrolytesTitle,
      NutrientsOption.vitamins => l.onboardingNutrientsOptionVitaminsTitle,
      NutrientsOption.minerals => l.onboardingNutrientsOptionMineralsTitle,
    };
    final footer = switch (nutrient) {
      NutrientsOption.macros => l.onboardingNutrientsOptionMacrosFooter,
      NutrientsOption.riskFactors => l.onboardingNutrientsOptionRiskFactorsFooter,
      NutrientsOption.electrolytes => l.onboardingNutrientsOptionElectrolytesFooter,
      NutrientsOption.vitamins => l.onboardingNutrientsOptionVitaminsFooter,
      NutrientsOption.minerals => l.onboardingNutrientsOptionMineralsFooter,
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
