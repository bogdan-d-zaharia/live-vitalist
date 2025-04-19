import 'package:flutter/material.dart';
import 'aliment.dart';
import 'aliment_editor/aliment_editor.dart';
import 'custom_card.dart';
import 'day.dart';
import 'models/reference_fields_model.dart';
import 'notification_handler.dart';
import 'settings.dart';

class MealsJournal extends StatelessWidget {
  const MealsJournal({
    required this.date,
    required this.day,
    required this.refresh,
    super.key,
  });

  final DateTime date;
  final Day day;
  final void Function() refresh;

  void saveDay() {
    day.save(date);
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> elements = [
      MealElement(
        title: {
          'ENG': 'Breakfast',
          'ROU': 'Mic Dejun',
        }[SettingsData.language]!,
        aliments: day.breakfast,
        saver: saveDay,
      ),
      MealElement(
        title: {
          'ENG': 'Lunch',
          'ROU': 'Pranz',
        }[SettingsData.language]!,
        aliments: day.lunch,
        saver: saveDay,
      ),
      MealElement(
        title: {
          'ENG': 'Dinner',
          'ROU': 'Cina',
        }[SettingsData.language]!,
        aliments: day.dinner,
        saver: saveDay,
      ),
    ];

    final Widget divider = Divider(
      color: Colors.grey[300],
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

class MealElement extends StatefulWidget {
  const MealElement({
    required this.title,
    required this.aliments,
    required this.saver,
    super.key,
  });

  final String title;
  final List<Aliment> aliments;
  final void Function() saver;

  @override
  State<MealElement> createState() => _MealElementState();
}

class _MealElementState extends State<MealElement> {
  Future<void> openMeal(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MealEditor(
          title: widget.title,
          aliments: widget.aliments,
        ),
      ),
    );

    setState(() {
      /// Exited the `MealEditor` and the values updated.
    });
    widget.saver();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, double> values = Day.sumFields(widget.aliments);
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => openMeal(context),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.title),
                        Text(
                          '${values['kcals']?.round() ?? 0} ${NutrientsHandler.model['kcals']?['translations']?[SettingsData.language]?.toLowerCase() ?? ''}',
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
            color: Colors.grey[300],
            thickness: 0.5,
            width: 0.0,
            indent: 8.0,
            endIndent: 8.0,
          ),
          AspectRatio(
            aspectRatio: 1.0,
            child: InkWell(
              //TODO: Copied from `_MealEditorState` to `_MealElementState`
              onTap: () async {
                final InstancedAliment newAliment =
                    InstancedAliment(alimentID: '', servingSize: 1.0);
                await AlimentEditor.editInstance(newAliment, context);
                if (AlimentBank.aliments.keys.contains(newAliment.alimentID)) {
                  widget.aliments.add(newAliment);
                }
                setState(() {});
                widget.saver();
              },
              child: Center(child: Icon(Icons.add_rounded)),
            ),
          ),
        ],
      ),
    );
  }
}

class MealEditor extends StatefulWidget {
  const MealEditor({
    required this.title,
    required this.aliments,
    super.key,
  });

  final String title;
  final List<Aliment> aliments;

  @override
  State<MealEditor> createState() => _MealEditorState();
}

class _MealEditorState extends State<MealEditor> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> elements = widget.aliments
        .map<Widget>(
          (aliment) => AlimentWidget(
            aliment: aliment,
            deleteAliment: () {
              setState(() {
                widget.aliments.remove(aliment);
              });
            },
            onTap: () async {
              if (aliment is InstancedAliment) {
                await AlimentEditor.editInstance(aliment, context);
              } else if (aliment is TemporaryAliment) {
                await AlimentEditor.editAliment(aliment, context);
              }
              setState(() {});
            },
            onLongPress: () => AlimentEditor.editAliment(aliment, context)
                .then((_) => setState(() {})),
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
            InstancedAliment(alimentID: '', servingSize: 1.0);
        await AlimentEditor.editInstance(newAliment, context);
        if (AlimentBank.aliments.keys.contains(newAliment.alimentID)) {
          widget.aliments.add(newAliment);
        }
        setState(() {});
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
            alimentData:
                AlimentData(name: 'Temporary aliment', referenceSize: 1.0),
            servingSize: 1.0);
        if (await AlimentEditor.editAliment(newAliment, context)) {
          widget.aliments.add(newAliment);
        }
        setState(() {});
      },
      additional: [],
    ));

    final Widget divider = Divider(
      color: Colors.grey[300],
      thickness: 0.5,
      height: 0.0,
    );

    for (int i = elements.length - 1; i > 0; i--) {
      elements.insert(i, divider);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          ElevatedButton(
            onPressed: () => NotificationHandler.showListNotification(
                widget.aliments, widget.title),
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
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 16.0,
                            letterSpacing: -0.5,
                          ),
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

class AlimentWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final values = aliment.fields;
    return ElementWidget(
      title: aliment.getAliment.name,
      subTitle:
          '${values['kcals']?.round() ?? 0} ${NutrientsHandler.model['kcals']?['translations']?[SettingsData.language]?.toLowerCase() ?? ''}, ${aliment.servingSize} ${aliment.unit ?? ''}',
      onTap: onTap,
      onLongPress: onLongPress,
      additional: [
        VerticalDivider(
          color: Colors.grey[300],
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
