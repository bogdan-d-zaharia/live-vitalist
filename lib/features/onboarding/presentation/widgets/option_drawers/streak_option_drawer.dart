import 'package:flutter/material.dart';
import 'package:live_vitalist/core/theme/custom_icons.dart';
import 'package:live_vitalist/features/onboarding/domain/options/streak_option.dart';
import 'package:live_vitalist/features/onboarding/presentation/widgets/option_card.dart';
import 'package:live_vitalist/l10n/app_localizations.dart';

class StreakOptionDrawer extends StatelessWidget {
  final StreakOption streak;
  final bool isSelected;
  final VoidCallback onTap;

  const StreakOptionDrawer({
    super.key,
    required this.streak,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final icon = switch (streak) {
      StreakOption.show => CustomIcons.streakOn,
      StreakOption.hide => CustomIcons.streakOff,
      // _ => Icons.account_balance_rounded,
    };
    final title = switch (streak) {
      StreakOption.show => l.onboardingStreakOptionShowTitle,
      StreakOption.hide => l.onboardingStreakOptionHideTitle,
    };
    final footer = switch (streak) {
      StreakOption.show => l.onboardingStreakOptionShowFooter,
      StreakOption.hide => l.onboardingStreakOptionHideFooter,
    };

    return OptionCard(
      icon: icon,
      title: title,
      footer: footer,
      isSelected: isSelected,
      onTap: onTap,
    );
  }
}
