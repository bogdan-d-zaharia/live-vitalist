import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/aliment/domain/aliment_extensions.dart';
import 'package:live_vitalist/day/domain/meal.dart';
import 'package:live_vitalist/meals_journal/presentation/widgets/meal_editor.dart';
import 'package:live_vitalist/meals_journal/presentation/widgets/meal_element.dart';

import '../aliment/domain/aliment.dart';
import '../aliment/data/aliment_bank.dart';
import '../aliment_editor/instance_editor.dart';
import '../core/presentation/widgets/custom_card.dart';
import '../day/domain/day.dart';
import '../day/data/day_provider.dart';
import '../nutrient/data/nutrient_provider.dart';
import '../palette.dart';
import '../settings/data/settings_data.dart';
import '../string_input.dart';

class MealsJournal extends ConsumerWidget {
  const MealsJournal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = ref.watch(syncSelectedDaysProvider)?.firstOrNull ?? Day();
    final dayNotifier = ref.read(dayCacheProvider.notifier);

    final date = ref.watch(selectedDatesProvider).first;

    final bank = ref.watch(alimentBankProvider);
    final nutrients = ref.watch(nutrientsProvider).data;

    final List<Widget> elements = day.meals.map<Widget>(
      (meal) {
        final Map<String, double> values = meal.aliments.summedFields(bank);
        final int kcals = values['kcals']?.round() ?? 0;
        return MealElement(
          title: meal.name,
          subtitle:
              '$kcals ${nutrients['kcals']?.translations[SettingsData.language]?.toLowerCase() ?? ''}',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MealEditor(
                  mealName: meal.name,
                  date: date,
                ),
              ),
            );
          },
          onLongPress: () async {
            final isDelete = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Delete meal?'),
                content: Text('Are you sure you want to delete this meal?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            );

            if (isDelete == true) {
              dayNotifier.removeMeal(date, day, meal);
            }
          },
          onAdd: () async {
            //TODO: Copied to `MealEditor`

            final newAliment = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InstanceEditor(
                  initialAliment: InstancedAliment.empty,
                ),
              ),
            );

            if (newAliment != null && newAliment.alimentID != '') {
              meal.aliments.add(newAliment);
              dayNotifier.save(date, day);
            }
          },
        );
      },
    ).toList();

    // final List<Widget> elements = day.meals.map((meal) {
    //   return ListTile(
    //     title: Text(meal.name),
    //     onTap: () {
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //           builder: (_) => MealEditor(mealName: meal.name, date: date),
    //         ),
    //       );
    //     },
    //   );
    // }).toList();

    final Widget divider = Divider(
      color: Palette.divGrey,
      thickness: 0.5,
      height: 0.0,
    );
    for (int i = elements.length - 1; i > 0; i--) {
      elements.insert(i, divider);
    }

    return CustomCard(
      logo: Icon(Icons.menu_book_rounded),
      title: {
        'ENG': 'Meals Journal',
        'ROU': 'Jurnal Mese'
      }[SettingsData.language],
      action: SizedBox(
        height: 36.0,
        child: Center(
          child: TextButton.icon(
            onPressed: () async {
              final newMealName = await showDialog(
                context: context,
                builder: (_) => Dialog(
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

              if (!day.meals.map((e) => e.name).contains(newMealName)) {
                dayNotifier.addMeal(date, day, Meal(name: newMealName));
              }
            },
            label: Text('Add Meal'),
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
