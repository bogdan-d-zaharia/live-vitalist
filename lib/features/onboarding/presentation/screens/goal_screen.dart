import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/features/onboarding/domain/options/goal_option.dart';
import 'package:live_vitalist/features/onboarding/presentation/controllers/onboarding_controller.dart';
import 'package:live_vitalist/features/onboarding/presentation/screens/selectable_screen.dart';
import 'package:live_vitalist/features/onboarding/presentation/widgets/option_drawers/goal_option_drawer.dart';

class GoalScreen extends ConsumerWidget {
  const GoalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalProvider = onboardingControllerProvider
        .select((onboardingState) => onboardingState.data.goal);
    final controllerNotifier = ref.read(onboardingControllerProvider.notifier);
    final selected = ref.watch(goalProvider);
    final options = GoalOption.values
        .map((e) => GoalOptionDrawer(
              goal: e,
              isSelected: e == selected,
              onTap: () => controllerNotifier.setGoal(e),
            ))
        .toList();

    return SelectableScreen(
      question: "What is your main goal?",
      options: options,
    );
  }
}
