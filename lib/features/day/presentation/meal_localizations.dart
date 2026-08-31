import 'package:live_vitalist/features/day/domain/meal.dart';
import 'package:live_vitalist/l10n/app_localizations.dart';

extension MealLocalizations on Meal {
  String displayName(AppLocalizations l) {
    return switch (key) {
      'breakfast' => l.mealsJournalBreakfast,
      'lunch' => l.mealsJournalLunch,
      'dinner' => l.mealsJournalDinner,
      _ => key,
    };
  }
}
