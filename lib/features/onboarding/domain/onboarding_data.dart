// ignore_for_file: annotate_overrides

import 'package:live_vitalist/features/onboarding/domain/options/goal_option.dart';
import 'package:live_vitalist/features/onboarding/domain/options/nutrients_option.dart';
import 'package:live_vitalist/features/onboarding/domain/options/streak_option.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_data.freezed.dart';

@freezed
class OnboardingData with _$OnboardingData {
  final GoalOption goal;
  final Set<NutrientsOption> nutrients;
  final StreakOption streak;

  const OnboardingData({
    required this.goal,
    required this.nutrients,
    required this.streak,
  });

  static const preset = OnboardingData(
    goal: GoalOption.loseWeight,
    nutrients: <NutrientsOption>{},
    streak: StreakOption.show,
  );
}
