import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/l10n/app_localizations.dart';
import 'package:live_vitalist/features/aliment/domain/aliment_extensions.dart';
import 'package:live_vitalist/features/day/domain/meal.dart';
import 'package:live_vitalist/features/day/presentation/meal_localizations.dart';
import 'package:live_vitalist/features/meals_journal/presentation/widgets/custom_divider.dart';
import 'package:live_vitalist/features/meals_journal/presentation/widgets/meal_element.dart';
import 'package:live_vitalist/features/super_search/presentation/utils/super_search_navigation.dart';

import '../aliment/data/aliment_bank.dart';
import '../../core/presentation/widgets/custom_card.dart';
import '../day/domain/day.dart';
import '../day/data/day_provider.dart';
import '../../core/presentation/widgets/data_input/string_input.dart';

class MealsJournal extends ConsumerWidget {
  final Future<void> Function(String mealKey, DateTime date) onOpenMeal;

  const MealsJournal({
    super.key,
    required this.onOpenMeal,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final day = ref.watch(syncSelectedDaysProvider)?.firstOrNull ?? Day();
    final dayNotifier = ref.read(dayCacheProvider.notifier);
    final date = ref.watch(selectedDatesProvider).first;
    final bank = ref.watch(alimentBankProvider);
    final List<Widget> elements = day.meals.map<Widget>(
      (meal) {
        final Map<String, double> values = meal.aliments.summedFields(bank);
        final int kcals = values['kcals']?.round() ?? 0;
        return MealElement(
          title: meal.displayName(l),
          subtitle: l.mealsJournalCalories(kcals),
          onTap: () => onOpenMeal(meal.key, date),
          onLongPress: () async {
            final isDelete = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(l.mealsJournalDeleteMealTitle),
                content: Text(l.mealsJournalDeleteMealMessage),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l.actionCancel),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(l.actionDelete),
                  ),
                ],
              ),
            );

            if (isDelete == true) {
              dayNotifier.removeMeal(date, meal.key);
            }
          },
          onAdd: () => SuperSearchNavigation.open(context, ref,
              date: date, mealName: meal.key),
        );
      },
    ).toList();

    for (int i = elements.length - 1; i > 0; i--) {
      elements.insert(i, CustomDivider());
    }

    return CustomCard(
      logo: Icon(Icons.menu_book_rounded),
      title: l.mealsJournalTitle,
      action: SizedBox(
        height: 36.0,
        child: Center(
          child: TextButton.icon(
            onPressed: () async {
              final newMealName = await showDialog(
                context: context,
                builder: (context) => Dialog(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 16.0),
                    child: StringInput(
                      initString: 'meal #${day.meals.length + 1}',
                      submit: (newKey) {
                        final key = newKey.trim();
                        Navigator.pop(context, key);
                      },
                    ),
                  ),
                ),
              );
              if (newMealName == null) return;

              if (!day.meals.map((e) => e.key).contains(newMealName)) {
                dayNotifier.addMeal(date, Meal(key: newMealName));
              }
            },
            label: Text(l.mealsJournalAddMeal),
            icon: Icon(Icons.add_rounded),
            iconAlignment: IconAlignment.end,
            style: ButtonStyle(
                padding: WidgetStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 8.0))),
          ),
        ),
      ),
      child: Column(
        children: elements,
      ),
    );
  }
}
