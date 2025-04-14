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
      color: Colors.black.withValues(alpha: 0.1),
      thickness: 0.5,
      height: 0.0,
    );
    for (int i = elements.length - 1; i > 0; i--) {
      elements.insert(i, divider);
    }

    return CustomCard(
      title: {
        'ENG': 'Meals jurnal',
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
    return InkWell(
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
                  '${values['kcals']?.round() ?? 0} ${NutrientsHandler.model['kcals']!['translations'][SettingsData.language]}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.0),
                ),
              ],
            ),
          ],
        ),
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

    for (int i = elements.length - 1; i > 0; i--) {
      elements.insert(
        i,
        Divider(
          thickness: 1.0,
          height: 0.0,
          indent: 16.0,
          endIndent: 16.0,
          color: Colors.black.withValues(alpha: 0.1),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          ElevatedButton(
            onPressed: () =>
                NotificationHandler.showListNotification(widget.aliments),
            child: Text('Show Notification'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            const TitleView(titleTxt: 'Aliments'),
            Material(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
                side: BorderSide(
                  color: Colors.black.withValues(alpha: 0.1),
                  width: 1.0,
                ),
              ),
              clipBehavior: Clip.hardEdge,
              child: Column(children: elements),
            ),
          ],
        ),
      ),
    );
  }
}

class TitleView extends StatelessWidget {
  final String titleTxt;
  final String subTxt;

  const TitleView({
    super.key,
    this.titleTxt = "",
    this.subTxt = "",
  });

  @override
  Widget build(BuildContext context) {
    const String fontName = 'Roboto';
    const Color lightText = Color(0xFF4A6572);
    const Color nearlyDarkBlue = Color(0xFF2633C5);
    const Color darkText = Color(0xFF253840);

    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24),
      child: Row(
        children: <Widget>[
          Text(
            titleTxt,
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontFamily: fontName,
              fontWeight: FontWeight.w500,
              fontSize: 18,
              letterSpacing: 0.5,
              color: lightText,
            ),
          ),
          if (subTxt != '')
            InkWell(
              highlightColor: Colors.transparent,
              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  children: <Widget>[
                    Text(
                      subTxt,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontFamily: fontName,
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        letterSpacing: 0.5,
                        color: nearlyDarkBlue,
                      ),
                    ),
                    const SizedBox(
                      height: 38,
                      width: 26,
                      child: Icon(
                        Icons.arrow_forward,
                        color: darkText,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            )
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
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Roboto',
                      fontSize: 18.0,
                      letterSpacing: -0.5,
                    ),
                  ),
                  if (subTitle != '')
                    Row(
                      children: [
                        const SizedBox(width: 4.0),
                        Text(
                          subTitle,
                          style: TextStyle(
                            color: Color.lerp(Colors.black, Colors.white, 0.6),

                            /// 153 = 60/100*255
                            /// color: Color.fromARGB(255, 153, 153, 153),
                            fontFamily: 'Roboto',
                            fontSize: 13.0,
                            letterSpacing: 0.0,
                          ),
                        ),
                      ],
                    )
                ],
              ),
            ),
            ...additional,
          ],
        ),
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
          '${values['kcals']?.round() ?? 0.0} kcal, ${aliment.servingSize} ${aliment.unit ?? ''}',
      onTap: onTap,
      onLongPress: onLongPress,
      additional: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Container(
            width: 1.0,
            height: 24.0,
            decoration: BoxDecoration(
              color: const Color(0xffd6d6d8),
              borderRadius: BorderRadius.circular(1.0),
            ),
          ),
        ),
        InkWell(
          onTap: deleteAliment,
          child: Container(
            width: 32.0,
            height: 32.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(
                color: Colors.black.withValues(alpha: 0.1),
                width: 0.8,
              ),
            ),
            child: Center(
              child: Container(
                width: 19.0,
                height: 2.0,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(1.0),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
