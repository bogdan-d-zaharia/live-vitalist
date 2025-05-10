import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
import 'settings.dart';

class MealsJournal extends ConsumerWidget {
  const MealsJournal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = ref.watch(selectedDaysProvider).when(
          data: (data) => data.first,
          error: (error, stackTrace) =>
              Error.throwWithStackTrace(error, stackTrace),
          loading: () => Day(),
        );
    final date = ref.watch(selectedDatesProvider).first;

    final bank = ref.watch(alimentBankProvider);
    final model = ref.watch(nutrientStateProvider).data;
    final List<Widget> elements = day.meals.map<Widget>(
      (meal) {
        final Map<String, double> values = meal.aliments.summedFields(bank);
        final int kcals = values['kcals']?.round() ?? 0;
        return MealElement(
          title: meal.name,
          subtitle:
              '$kcals ${model['kcals']?.translations[SettingsData.language]?.toLowerCase() ?? ''}',
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
          onAdd: () async {
            //TODO: Copied tom `MealEditor`
            final InstancedAliment newAliment =
                InstancedAliment(alimentID: '', servingSize: 1.0, unit: 'g');

            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InstanceEditor(
                  aliment: newAliment,
                ),
              ),
            );

            if (newAliment.alimentID != '') {
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
      title: {
        'ENG': 'Meals journal',
        'ROU': 'Jurnal mese'
      }[SettingsData.language],
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
    required this.onAdd,
    super.key,
  });

  final String title;
  final String subtitle;
  final void Function() onTap;
  final void Function() onAdd;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onTap,
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

    void updateDay() => ref.read(dayCacheProvider.notifier).setDay(date, day);

    final List<Widget> elements = meal.aliments
        .map<Widget>(
          (aliment) => AlimentWidget(
            aliment: aliment,
            deleteAliment: () {
              meal.aliments.remove(aliment);
              updateDay();
            },
            onTap: () async {
              if (aliment is InstancedAliment) {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InstanceEditor(
                      aliment: aliment,
                    ),
                  ),
                );
              }
              updateDay();
            },
            onLongPress: () async {
              if (aliment is InstancedAliment) {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AlimentDataEditor(
                      data: aliment.readDataRef(bank),
                    ),
                  ),
                );
              }
              updateDay();
            },
          ),
        )
        .toList();

    elements.add(ElementWidget(
      title: {
        'ENG': 'Add aliment',
        'ROU': 'Adaugare aliment',
      }[SettingsData.language]!,
      subTitle: '',
      onTap: () async {
        final InstancedAliment newAliment =
            InstancedAliment(alimentID: '', servingSize: 1.0, unit: 'g');

        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InstanceEditor(
              aliment: newAliment,
            ),
          ),
        );

        if (newAliment.alimentID != '') {
          meal.aliments.add(newAliment);
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
