// ignore_for_file: annotate_overrides

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:live_vitalist/features/onboarding/domain/onboarding_data.dart';
import 'package:live_vitalist/features/onboarding/domain/options/goal_option.dart';
import 'package:live_vitalist/features/onboarding/domain/options/nutrients_option.dart';
import 'package:live_vitalist/features/onboarding/domain/options/streak_option.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_controller.freezed.dart';
part 'onboarding_controller.g.dart';

@freezed
class OnboardingControllerState with _$OnboardingControllerState {
  final int stepIndex;
  final OnboardingData data;

  const OnboardingControllerState({
    required this.stepIndex,
    required this.data,
  });

  static const preset = OnboardingControllerState(
    stepIndex: 0,
    data: OnboardingData.preset,
  );
}

@riverpod
class OnboardingController extends _$OnboardingController {
  @override
  OnboardingControllerState build() => OnboardingControllerState.preset;

  void _setData(OnboardingData data) => state = state.copyWith(data: data);
  void _setIndex(int index) => state = state.copyWith(stepIndex: index);

  void nextStep() => _setIndex(state.stepIndex + 1);
  void previousStep() =>
      state.stepIndex != 0 ? _setIndex(state.stepIndex - 1) : null;

  void setGoal(GoalOption goal) {
    _setData(state.data.copyWith(goal: goal));

    final Set<NutrientsOption> nutrients = switch (goal) {
      GoalOption.loseWeight => {},
      GoalOption.buildMuscle => {
          NutrientsOption.macros,
        },
      GoalOption.improveHealth => {
          NutrientsOption.macros,
          NutrientsOption.riskFactors,
        },
      GoalOption.improvePerformance => {
          NutrientsOption.macros,
          NutrientsOption.electrolytes,
          NutrientsOption.minerals,
        }
    };
    _setData(state.data.copyWith(nutrients: nutrients));
  }

  void toggleNutrient(NutrientsOption nutrient) {
    final nutrients = state.data.nutrients;
    final updated = nutrients.contains(nutrient)
        ? (nutrients.toSet()..remove(nutrient))
        : (nutrients.toSet()..add(nutrient));
    _setData(state.data.copyWith(nutrients: updated));
  }

  void setStreak(StreakOption streak) =>
      _setData(state.data.copyWith(streak: streak));
}
