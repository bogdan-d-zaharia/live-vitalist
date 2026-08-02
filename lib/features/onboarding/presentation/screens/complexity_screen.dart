import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/features/onboarding/domain/onboarding_step.dart';
import 'package:live_vitalist/features/onboarding/domain/options/complexity_option.dart';
import 'package:live_vitalist/features/onboarding/presentation/controllers/onboarding_controller.dart';
import 'package:live_vitalist/features/onboarding/presentation/screens/selectable_screen.dart';
import 'package:live_vitalist/features/onboarding/presentation/widgets/option_drawers/complexity_option_drawer.dart';

class ComplexityScreen extends ConsumerWidget {
  const ComplexityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final complexityProvider = onboardingControllerProvider
        .select((onboardingState) => onboardingState.data.complexity);
    final controllerNotifier = ref.read(onboardingControllerProvider.notifier);
    final selected = ref.watch(complexityProvider);
    final optionsEntries = ComplexityOption.values.map((e) => MapEntry(
        e, ComplexityOptionDrawer(complexity: e, isSelected: e == selected)));

    return SelectableScreen(
      question: OnboardingStep.complexity.question,
      options: Map.fromEntries(optionsEntries),
      selected: selected,
      select: controllerNotifier.setComplexity,
    );
  }
}
