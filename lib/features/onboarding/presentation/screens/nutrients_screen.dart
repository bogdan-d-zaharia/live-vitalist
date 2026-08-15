import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/features/onboarding/domain/options/nutrients_option.dart';
import 'package:live_vitalist/features/onboarding/presentation/controllers/onboarding_controller.dart';
import 'package:live_vitalist/features/onboarding/presentation/screens/selectable_screen.dart';
import 'package:live_vitalist/features/onboarding/presentation/widgets/option_drawers/nutrients_option_drawer.dart';

class NutrientsScreen extends ConsumerWidget {
  const NutrientsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nutrientsProvider = onboardingControllerProvider
        .select((onboardingState) => onboardingState.data.nutrients);
    final controllerNotifier = ref.read(onboardingControllerProvider.notifier);
    final selected = ref.watch(nutrientsProvider);
    final options = NutrientsOption.values
        .map((e) => NutrientsOptionDrawer(
              nutrient: e,
              isSelected: selected.contains(e),
              onTap: () => controllerNotifier.toggleNutrient(e),
            ))
        .toList();

    return SelectableScreen(
      question: "What else are you tracking besides calories?",
      options: options,
    );
  }
}
