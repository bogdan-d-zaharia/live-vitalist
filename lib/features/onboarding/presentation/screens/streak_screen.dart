import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/features/onboarding/domain/onboarding_step.dart';
import 'package:live_vitalist/features/onboarding/domain/options/streak_option.dart';
import 'package:live_vitalist/features/onboarding/presentation/controllers/onboarding_controller.dart';
import 'package:live_vitalist/features/onboarding/presentation/screens/selectable_screen.dart';
import 'package:live_vitalist/features/onboarding/presentation/widgets/option_drawers/streak_option_drawer.dart';

class StreakScreen extends ConsumerWidget {
  const StreakScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streakProvider = onboardingControllerProvider
        .select((onboardingState) => onboardingState.data.streak);
    final controllerNotifier = ref.read(onboardingControllerProvider.notifier);
    final selected = ref.watch(streakProvider);
    final optionsEntries = StreakOption.values.map((e) =>
        MapEntry(e, StreakOptionDrawer(streak: e, isSelected: e == selected)));

    return SelectableScreen(
      question: OnboardingStep.streak.question,
      options: Map.fromEntries(optionsEntries),
      selected: ref.watch(streakProvider),
      select: controllerNotifier.setStreak,
    );
  }
}
