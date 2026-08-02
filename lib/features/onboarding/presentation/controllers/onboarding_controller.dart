// ignore_for_file: annotate_overrides

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:live_vitalist/features/onboarding/domain/onboarding_data.dart';
import 'package:live_vitalist/features/onboarding/domain/options/complexity_option.dart';
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

  void setComplexity(ComplexityOption complexity) =>
      _setData(state.data.copyWith(complexity: complexity));
  void setStreak(StreakOption streak) =>
      _setData(state.data.copyWith(streak: streak));
}
