// ignore_for_file: annotate_overrides

import 'package:live_vitalist/features/onboarding/domain/options/complexity_option.dart';
import 'package:live_vitalist/features/onboarding/domain/options/streak_option.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_data.freezed.dart';

@freezed
class OnboardingData with _$OnboardingData {
  final ComplexityOption complexity;
  final StreakOption streak;

  const OnboardingData({
    required this.complexity,
    required this.streak,
  });

  static const preset = OnboardingData(
    complexity: ComplexityOption.normal,
    streak: StreakOption.show,
  );
}
