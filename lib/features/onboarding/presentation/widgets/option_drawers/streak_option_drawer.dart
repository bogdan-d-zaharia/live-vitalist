import 'package:flutter/material.dart' hide SelectableText;
import 'package:live_vitalist/features/onboarding/domain/options/streak_option.dart';
import 'package:live_vitalist/features/onboarding/presentation/widgets/selectable_text.dart';

class StreakOptionDrawer extends StatelessWidget {
  final StreakOption streak;
  final bool isSelected;
  const StreakOptionDrawer({
    super.key,
    required this.streak,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final string = switch (streak) {
      StreakOption.show => 'Yes! I love streaks!',
      StreakOption.hide => 'No, I find them annoying.',
    };
    final text = SelectableText(string, isSelected: isSelected);
    final visibility = switch (streak) {
      StreakOption.show => Icon(Icons.visibility_outlined),
      StreakOption.hide => Icon(Icons.visibility_off_outlined),
    };
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [text, visibility],
    );
  }
}
