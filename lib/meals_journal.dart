import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/aliment/aliment_extensions.dart';

import 'aliment/aliment.dart';
import 'aliment/aliment_bank_provider.dart';
import 'aliment_editor/aliment_data_editor.dart';
import 'aliment_editor/instance_editor.dart';
import 'custom_card.dart';
import 'day/day.dart';
import 'day/day_provider.dart';
import 'notification_handler.dart';
import 'nutrient/nutrient_provider.dart';
import 'palette.dart';
import 'settings_data.dart';
import 'string_input.dart';

class MealsJournal extends ConsumerWidget {
  const MealsJournal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = ref.watch(cachedSelectedDaysProvider).firstOrNull ?? Day();
    final dayNotifier = ref.read(dayCacheProvider.notifier);

    final date = ref.watch(selectedDatesProvider).first;

    final bank = ref.watch(alimentBankProvider);
    final nutrients = ref.watch(nutrientStateProvider).data;

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
              dayNotifier.setDay(
                date,
                Day(
                  meals: [...day.meals]
                    ..removeWhere((element) => element.name == meal.name),
                ),
              );
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
              ref.read(dayCacheProvider.notifier).setDay(date, day);
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
                dayNotifier.setDay(
                    date, Day(meals: [...day.meals, Meal(name: newMealName)]));
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

class MealElement extends StatelessWidget {
  const MealElement({
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.onLongPress,
    required this.onAdd,
    super.key,
  });

  final String title;
  final String subtitle;
  final void Function() onTap;
  final void Function() onLongPress;
  final void Function() onAdd;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onTap,
              onLongPress: onLongPress,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title),
                        Text(
                          subtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          VerticalDivider(
            color: Palette.divGrey,
            thickness: 0.5,
            width: 0.0,
            indent: 8.0,
            endIndent: 8.0,
          ),
          AspectRatio(
            aspectRatio: 1.0,
            child: InkWell(
              onTap: onAdd,
              child: Center(child: Icon(Icons.add_rounded)),
            ),
          ),
        ],
      ),
    );
  }
}

class MealEditor extends ConsumerWidget {
  const MealEditor({
    required this.mealName,
    required this.date,
    super.key,
  });

  final String mealName;
  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = ref.watch(dayCacheProvider)[date]!;
    final meal = day.meals.firstWhere((m) => m.name == mealName);
    final bank = ref.watch(alimentBankProvider);
    final bankNotifier = ref.read(alimentBankProvider.notifier);

    void updateDay() => ref.read(dayCacheProvider.notifier).setDay(date, day);

    final List<Widget> elements = meal.aliments.map<Widget>(
      (aliment) {
        final idx = meal.aliments.indexOf(aliment);
        return AlimentWidget(
          aliment: aliment,
          deleteAliment: () {
            meal.aliments.remove(aliment);
            updateDay();
          },
          onTap: () async {
            Aliment? newAliment;
            if (aliment is InstancedAliment) {
              newAliment = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InstanceEditor(
                    initialAliment: aliment,
                  ),
                ),
              );
            } else if (aliment is TemporaryAliment) {
              final newData = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AlimentDataEditor(
                    initialData: aliment.alimentData,
                  ),
                ),
              );
              if (newData != null) {
                newAliment = aliment.copyWith(alimentData: newData);
              }
            }
            if (newAliment != null) {
              meal.aliments
                ..removeAt(idx)
                ..insert(idx, newAliment);
            }
            updateDay();
          },
          onLongPress: () async {
            if (aliment is InstancedAliment) {
              final initialData = aliment.readDataRef(bank);
              final data = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AlimentDataEditor(
                    initialData: initialData,
                  ),
                ),
              );
              if (data != null) {
                bankNotifier.setAliment(aliment.alimentID, data);
              }
            } else if (aliment is TemporaryAliment) {
              final newData = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AlimentDataEditor(
                    initialData: aliment.alimentData,
                  ),
                ),
              );

              if (newData != null) {
                meal.aliments
                  ..removeAt(idx)
                  ..insert(idx, aliment.copyWith(alimentData: newData));
              }

              updateDay();
            }
          },
        );
      },
    ).toList();

    elements.add(ElementWidget(
      title: {
        'ENG': 'Add aliment',
        'ROU': 'Adaugare aliment',
      }[SettingsData.language]!,
      subTitle: '',
      onTap: () async {
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
          ref.read(dayCacheProvider.notifier).setDay(date, day);
        }
      },
      additional: [],
    ));

    elements.add(ElementWidget(
      title: {
        'ENG': 'Add temporary aliment',
        'ROU': 'Adaugare aliment temporar',
      }[SettingsData.language]!,
      subTitle: '',
      onTap: () async {
        final TemporaryAliment newAliment = TemporaryAliment.empty;

        final newData = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AlimentDataEditor(
              initialData: newAliment.alimentData,
            ),
          ),
        );

        if (newData != null && newData.name != '') {
          meal.aliments.add(newAliment.copyWith(alimentData: newData));
          ref.read(dayCacheProvider.notifier).setDay(date, day);
        }
      },
      additional: [],
    ));

    final Widget divider = Divider(
      color: Palette.divGrey,
      thickness: 0.5,
      height: 0.0,
    );

    for (int i = elements.length - 1; i > 0; i--) {
      elements.insert(i, divider);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(mealName),
        actions: [
          TextButton(
            onPressed: () => NotificationHandler.showListNotification(
                meal.aliments, bank, mealName),
            child: Text('Show Notification'),
          ),
          SizedBox(width: 12.0),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView(
          children: [
            CustomCard(
              title: 'Aliments',
              child: Column(children: elements),
            ),
            SizedBox(height: 12.0),
          ],
        ),
      ),
    );
  }
}

class ElementWidget extends StatelessWidget {
  const ElementWidget({
    required this.title,
    required this.subTitle,
    required this.onTap,
    this.onLongPress,
    required this.additional,
    super.key,
  });

  final String title;
  final String subTitle;
  final void Function() onTap;
  final void Function()? onLongPress;
  final List<Widget> additional;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onTap,
              onLongPress: onLongPress,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontSize: 16.0, letterSpacing: -0.5),
                    ),
                    if (subTitle != '')
                      Text(
                        subTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          ...additional,
        ],
      ),
    );
  }
}

class AlimentWidget extends ConsumerWidget {
  const AlimentWidget({
    required this.aliment,
    required this.deleteAliment,
    required this.onTap,
    required this.onLongPress,
    super.key,
  });

  final Aliment aliment;
  final Function() deleteAliment;
  final Function() onTap;
  final Function() onLongPress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(nutrientStateProvider).data;
    final bank = ref.watch(alimentBankProvider);

    final values = aliment.readFields(bank);
    return ElementWidget(
      title: aliment.readDataRef(bank).name,
      subTitle:
          '${values['kcals']?.round() ?? 0} ${model['kcals']?.translations[SettingsData.language]?.toLowerCase() ?? ''}, ${aliment.servingSize} ${aliment.unit}',
      onTap: onTap,
      onLongPress: onLongPress,
      additional: [
        VerticalDivider(
          color: Palette.divGrey,
          thickness: 0.5,
          width: 0.0,
          indent: 8.0,
          endIndent: 8.0,
        ),
        //TODO: Used trial and error to replicate `AspectRatio` without
        // having the width vary.
        SizedBox(
          width: 53.0,
          child: InkWell(
            onTap: deleteAliment,
            child: Center(child: Icon(Icons.remove_rounded)),
          ),
        ),
      ],
    );
  }
}
