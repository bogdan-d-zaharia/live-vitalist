import 'package:flutter/material.dart';
import 'package:live_vitalist/core/theme/custom_icons.dart';
import 'package:live_vitalist/features/onboarding/domain/options/goal_option.dart';
import 'package:live_vitalist/features/onboarding/presentation/widgets/option_card.dart';

class GoalOptionDrawer extends StatelessWidget {
  final GoalOption goal;
  final bool isSelected;
  final VoidCallback onTap;

  const GoalOptionDrawer({
    super.key,
    required this.goal,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final icon = switch (goal) {
      GoalOption.loseWeight => CustomIcons.weight,
      GoalOption.buildMuscle => CustomIcons.muscle,
      GoalOption.improveHealth => CustomIcons.health,
      GoalOption.improvePerformance => CustomIcons.performance,
      // _ => Icons.account_balance_rounded,
    };
    final title = switch (goal) {
      GoalOption.loseWeight => "Lose Weight",
      GoalOption.buildMuscle => "Build Muscle",
      GoalOption.improveHealth => "Improve Health",
      GoalOption.improvePerformance => "Improve Performance",
    };

    return OptionCard(
      icon: icon,
      title: title,
      isSelected: isSelected,
      onTap: onTap,
    );
  }
}
