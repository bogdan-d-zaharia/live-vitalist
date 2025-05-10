import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'aliment/aliment.dart';
import 'aliment/aliment_bank_provider.dart';
import 'aliment_editor/aliment_data_editor.dart';
import 'aliment_editor/aliment_editor.dart';
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

    // final List<Widget> elements = day.meals
    //     .map((e) => MealElement(
    //           title: e.name,
    //           aliments: e.aliments,
    //           saver: () =>
    //               ref.read(dayCacheProvider.notifier).setDay(date, day),
    //         ))
    //     .toList();

    final List<Widget> elements = day.meals.map((meal) {
      return ListTile(
        title: Text(meal.name),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MealEditor(mealName: meal.name, date: date),
            ),
          );
        },
      );
    }).toList();

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

// class MealElement extends ConsumerStatefulWidget {
//   const MealElement({
//     required this.meal,
//     required this.date,
//     super.key,
//   });

//   final Meal meal;
//   final DateTime date;

//   @override
//   ConsumerState<MealElement> createState() => _MealElementState();
// }

// class _MealElementState extends ConsumerState<MealElement> {
//   Future<void> openMeal(BuildContext context) async {
//     await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => MealEditor(
//           mealName: widget.meal.name,
//           aliments: widget.meal.a,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final model = ref.watch(nutrientStateProvider).data;

//     final Map<String, double> values = widget.aliments.summedFields;
//     final int kcals = values['kcals']?.round() ?? 0;

//     return IntrinsicHeight(
//       child: Row(
//         children: [
//           Expanded(
//             child: InkWell(
//               onTap: () => openMeal(context),
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(widget.title),
//                         Text(
//                           '$kcals ${model['kcals']?.translations[SettingsData.language]?.toLowerCase() ?? ''}',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: 12.0,
//                             color: Colors.grey,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           VerticalDivider(
//             color: Palette.divGrey,
//             thickness: 0.5,
//             width: 0.0,
//             indent: 8.0,
//             endIndent: 8.0,
//           ),
//           AspectRatio(
//             aspectRatio: 1.0,
//             child: InkWell(
//               //TODO: Copied from `_MealEditorState` to `_MealElementState`
//               onTap: () async {
//                 final InstancedAliment newAliment = InstancedAliment(
//                     alimentID: '', servingSize: 1.0, unit: 'g');
//                 await AlimentEditor.editInstance(newAliment, context);
//                 if (AlimentBank.aliments.keys.contains(newAliment.alimentID)) {
//                   widget.aliments.add(newAliment);
//                 }
//                 setState(() {});
//                 widget.saver();
//               },
//               child: Center(child: Icon(Icons.add_rounded)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

//!-------------------------------------------------------------------------

// class MealEditor extends StatefulWidget {
//   const MealEditor({
//     required this.mealName,
//     required this.date,
//     super.key,
//   });

//   final String mealName;
//   final DateTime date;

//   @override
//   State<MealEditor> createState() => _MealEditorState();
// }

// class _MealEditorState extends State<MealEditor> {
//   @override
//   Widget build(BuildContext context) {
//     final day = ref.watch(dayCacheProvider)[date]!;
//     final meal = day.meals.firstWhere((m) => m.name == mealName);

//     final List<Widget> elements = widget.aliments
//         .map<Widget>(
//           (aliment) => AlimentWidget(
//             aliment: aliment,
//             deleteAliment: () {
//               setState(() {
//                 widget.aliments.remove(aliment);
//               });
//             },
//             onTap: () async {
//               if (aliment is InstancedAliment) {
//                 await AlimentEditor.editInstance(aliment, context);
//               } else if (aliment is TemporaryAliment) {
//                 await AlimentEditor.editAliment(aliment, context);
//               }
//               setState(() {});
//             },
//             onLongPress: () async {
//               if (await AlimentEditor.editAliment(aliment, context)) {
//                 setState(() {
//                   AlimentBank.save();
//                 });
//               }
//             },
//           ),
//         )
//         .toList();

//     elements.add(ElementWidget(
//       title: {
//         'ENG': 'Add aliment',
//         'ROU': 'Adaugare aliment',
//       }[SettingsData.language]!,
//       subTitle: '',
//       onTap: () async {
//?-------------------------------------------------------------------------

//         final InstancedAliment newAliment =
//             InstancedAliment(alimentID: '', servingSize: 1.0);
//         await AlimentEditor.editInstance(newAliment, context);
//         if (AlimentBank.aliments.keys.contains(newAliment.alimentID)) {
//           widget.aliments.add(newAliment);
//         }
//         setState(() {});
//       },
//       additional: [],
//     ));

//     elements.add(ElementWidget(
//       title: {
//         'ENG': 'Add temporary',
//         'ROU': 'Adaugare calorii',
//       }[SettingsData.language]!,
//       subTitle: '',
//       onTap: () async {
//         final TemporaryAliment newAliment = TemporaryAliment(
//             alimentData:
//                 AlimentData(name: 'Temporary aliment', referenceSize: 1.0),
//             servingSize: 1.0);
//         if (await AlimentEditor.editAliment(newAliment, context)) {
//           widget.aliments.add(newAliment);
//         }
//         setState(() {});
//       },
//       additional: [],
//     ));

//     final Widget divider = Divider(
//       color: Palette.divGrey,
//       thickness: 0.5,
//       height: 0.0,
//     );

//     for (int i = elements.length - 1; i > 0; i--) {
//       elements.insert(i, divider);
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.mealName),
//         actions: [
//           ElevatedButton(
//             onPressed: () => NotificationHandler.showListNotification(
//                 widget.aliments, widget.mealName),
//             child: Text('Show Notification'),
//           ),
//           SizedBox(width: 12.0),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 8.0),
//         child: ListView(
//           children: [
//             CustomCard(
//               title: 'Aliments',
//               child: Column(children: elements),
//             ),
//             SizedBox(height: 12.0),
//           ],
//         ),
//       ),
//     );
//   }
// }

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
    // final bankNotifier = ref.read(alimentBankProvider.notifier);
    final bank = ref.watch(alimentBankProvider);
    final bankNotifier = ref.watch(alimentBankProvider.notifier);
    final nutrients = ref.watch(nutrientStateProvider);

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
                        bank: bank,
                      ),
                    ));
              } else if (aliment is TemporaryAliment) {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AlimentDataEditor(
                      alimentData: aliment.alimentData,
                      nutrients: nutrients,
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
                      alimentData: aliment.alimentData,
                      nutrients: nutrients,
                    ),
                  ),
                );
                bankNotifier.setAliment(
                    aliment.alimentID, bank.aliments[aliment.alimentID]!);
                //TODO: Then we have to set the bank notifier.
              } else if (aliment is TemporaryAliment) {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AlimentDataEditor(
                        alimentData: aliment.alimentData,
                        nutrients: nutrients,
                      ),
                    ));
                updateDay();
              }
            },
          ),
        )
        .toList();
    //?--------------------------------------------_________________________________

    elements.add(ElementWidget(
      title: {
        'ENG': 'Add aliment',
        'ROU': 'Adaugare aliment',
      }[SettingsData.language]!,
      subTitle: '',
      onTap: () async {
        final InstancedAliment newAliment =
            InstancedAliment(alimentID: '', servingSize: 1.0, unit: 'g');

        await AlimentEditor.editInstance(newAliment, bank, context);

        if (newAliment.alimentID != '') {
          meal.aliments.add(newAliment);
          ref.read(dayCacheProvider.notifier).setDay(date, day);
        }
      },
      additional: [],
    ));

    elements.add(ElementWidget(
      title: {
        'ENG': 'Add temporary',
        'ROU': 'Adaugare calorii',
      }[SettingsData.language]!,
      subTitle: '',
      onTap: () async {
        final TemporaryAliment newAliment = TemporaryAliment(
          alimentData: AlimentData(
            name: 'Temporary aliment',
            unit: 'g',
            referenceSize: 1.0,
            referenceFields: {},
            unitSynonyms: {},
          ),
          servingSize: 1.0,
          unit: 'g',
        );
        if (await AlimentEditor.editAlimentData(
            newAliment, bank, nutrientState, context)) {
          widget.aliments.add(newAliment);
        }
        setState(() {});
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
          ElevatedButton(
            onPressed: () => NotificationHandler.showListNotification(
                meal.aliments, mealName),
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

    return Scaffold(
      appBar: AppBar(title: Text('Edit $mealName')),
      body: Column(
        children: [
          Row(
            children: [
              ElevatedButton(
                onPressed: () async {
                  final InstancedAliment aliment = InstancedAliment(
                      alimentID: '', servingSize: 1.0, unit: 'g');

                  await AlimentEditor.editInstance(aliment, context);

                  if (aliment.alimentID != '') {
                    meal.aliments.add(aliment);
                    ref.read(dayCacheProvider.notifier).setDay(date, day);
                  }
                },
                child: const Text('Add existing Aliment'),
              ),
              ElevatedButton(
                onPressed: () {
                  final AlimentData newAliment = AlimentData(
                    name: 'New Aliment',
                    unit: 'g',
                    referenceSize: 100.0,
                    referenceFields: {},
                    unitSynonyms: {},
                  );

                  final String newID = newAliment.hashCode.toString();

                  bankNotifier.setAliment(newID, newAliment);

                  meal.aliments.add(
                    InstancedAliment(
                        alimentID: newID, servingSize: 1.0, unit: 'g'),
                  );
                  ref.read(dayCacheProvider.notifier).setDay(date, day);
                },
                child: const Text('Add NEW Aliment'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: meal.aliments.length,
              itemBuilder: (context, index) {
                final aliment = meal.aliments[index];
                return ListTile(
                  title: Text('Aliment ${aliment.alimentID}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      meal.aliments.removeAt(index);
                      ref.read(dayCacheProvider.notifier).setDay(date, day);
                    },
                  ),
                );
              },
            ),
          ),
        ],
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

    final values = aliment.fields;
    return ElementWidget(
      title: aliment.getAliment.name,
      subTitle:
          '${values['kcals']?.round() ?? 0} ${model['kcals']?.translations[SettingsData.language]?.toLowerCase() ?? ''}, ${aliment.servingSize} ${aliment.unit ?? ''}',
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
