import 'package:flutter/material.dart';
import 'aliment.dart';
import 'aliment_bank_editor.dart';
import 'custom_card.dart';
import 'day.dart';
import 'notification_handler.dart';
import 'string_input.dart';

class MealsJournal extends StatelessWidget {
  const MealsJournal({
    required this.date,
    required this.day,
    super.key,
  });

  final DateTime date;
  final Day day;

  void saveDay() {
    day.save(date);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> elements = [
      MealElement(
        title: 'Mic Dejun',
        servedAliments: day.breakfast,
        saver: saveDay,
      ),
      MealElement(
        title: 'Pranz',
        servedAliments: day.lunch,
        saver: saveDay,
      ),
      MealElement(
        title: 'Cina',
        servedAliments: day.dinner,
        saver: saveDay,
      ),
    ];

    /// [0.0, 1.0, 2.0]; /// [0.0, n, 1.0, n, 2.0] ///
    for (int i = elements.length - 1; i > 0; i--) {
      elements.insert(i, SizedBox(height: 8.0));
    }

    return CustomCard(
      title: 'Jurnal mese',
      child: Column(
        children: elements,
      ),
    );
  }
}

class MealElement extends StatefulWidget {
  const MealElement({
    required this.title,
    required this.servedAliments,
    required this.saver,
    super.key,
  });

  final String title;
  final List<ServedAliment> servedAliments;
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
          servedAliments: widget.servedAliments,
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
    final Map<String, double> values = Day.sumFields(widget.servedAliments);
    return InkWell(
      onTap: () => openMeal(context),
      child: Row(
        children: [
          Container(
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: values.containsKey('kcals')
                ? Center(
                    child: Text(
                    '${values['kcals']?.round()} kcals',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12.0),
                  ))
                : null,
          ),
          Column(
            children: [
              Text(widget.title),
            ],
          ),
        ],
      ),
    );
  }
}

class MealEditor extends StatefulWidget {
  const MealEditor({
    required this.title,
    required this.servedAliments,
    super.key,
  });

  final String title;
  final List<ServedAliment> servedAliments;

  @override
  State<MealEditor> createState() => _MealEditorState();
}

class _MealEditorState extends State<MealEditor> {
  Future<void> editServedAliment(
    ServedAliment aliment,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServedAlimentEditor(aliment: aliment),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> elements = widget.servedAliments
        .map<Widget>(
          (servedAliment) => AlimentWidget(
            aliment: servedAliment,
            deleteAliment: () {
              setState(() {
                widget.servedAliments.remove(servedAliment);
              });
            },
            onTap: () async {
              await editServedAliment(servedAliment);
              setState(() {});
            },
            onLongPress: () => AlimentEditor.editAliment(
                    AlimentBank.getAliment(servedAliment.alimentID), context)
                .then(
              (value) {
                setState(() {
                  AlimentBank.save();
                });
              },
            ),
          ),
        )
        .toList();

    elements.add(ElementWidget(
      title: 'Adaugare aliment',
      subTitle: '',
      onTap: () async {
        final ServedAliment newAliment =
            ServedAliment(alimentID: '', servingSize: 1.0);
        await editServedAliment(newAliment);
        if (AlimentBank.aliments.keys.contains(newAliment.alimentID)) {
          widget.servedAliments.add(newAliment);
        }
        setState(() {});
      },
      additional: [],
    ));

    elements.add(ElementWidget(
      title: 'Adaugare calorii',
      subTitle: '',
      onTap: () {},
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
                NotificationHandler.showListNotification(widget.servedAliments),
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

  final ServedAliment aliment;
  final Function() deleteAliment;
  final Function() onTap;
  final Function() onLongPress;

  @override
  Widget build(BuildContext context) {
    final values = aliment.fields;
    return ElementWidget(
      title: AlimentBank.getAliment(aliment.alimentID).name,
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

class ServedAlimentEditor extends StatefulWidget {
  const ServedAlimentEditor({
    required this.aliment,
    super.key,
  });
  final ServedAliment aliment;

  @override
  State<ServedAlimentEditor> createState() => _ServedAlimentEditorState();
}

class _ServedAlimentEditorState extends State<ServedAlimentEditor> {
  String searchTerm = '';

  Widget _alimentSelector() {
    return SizedBox(
      child: DropdownButton<String>(
        isExpanded: true,
        hint: ListView(
          children: [
            Text(AlimentBank.aliments[widget.aliment.alimentID]?.name ?? '')
          ],
        ),
        items:

            /// Filter for the search term.
            AlimentBank.aliments.keys

                /// TODO: Ideea e ca se actualizeaza cand iesi si intri in dropdown...
                /// .where((element) => false)
                /// Create the dropdown
                .map((id) => DropdownMenuItem(
                    enabled: (searchTerm == '') ||
                        (AlimentBank.getAliment(id)
                            .name
                            .toLowerCase()
                            .contains(searchTerm.toLowerCase())),
                    value: id,
                    child: SizedBox(
                        width: 300.0,
                        child: Text(AlimentBank.getAliment(id).name))))
                .toList()

        /// Add the search box.
        /// ..insert(
        ///     0,
        ///     DropdownMenuItem(
        ///       value: null,
        ///       child: SizedBox(
        ///         width: 300.0,
        ///         child: StringInput(
        ///           hint: 'Search',
        ///           update: (p0) {
        ///             setState(() {
        ///               searchTerm = p0;
        ///             });
        ///           },
        ///         ),
        ///       ),
        ///     ))
        ,
        onChanged: (newID) {
          if (newID != null) {
            setState(() {
              widget.aliment.alimentID = newID;

              final Aliment aliment = AlimentBank.getAliment(newID);
              widget.aliment.unit = aliment.unitSizes?.keys.first;
            });
          }
        },
      ),
    );
  }

  Widget _inputServed() {
    return StringInput(
      hint: 'Served amount',
      initString: widget.aliment.servingSize.toString(),
      keyboardType: TextInputType.number,
      update: (p0) {
        setState(() {
          double? value = double.tryParse(p0);
          if (value != null) {
            widget.aliment.servingSize = value;
          }
        });
      },
    );
  }

  Widget? _unitSelector() {
    if (!AlimentBank.aliments.containsKey(widget.aliment.alimentID)) {
      return null;
    }
    final Aliment aliment = AlimentBank.getAliment(widget.aliment.alimentID);
    final List<String>? units = aliment.unitSizes?.keys.toList();
    if (units == null) return null;

    return SizedBox(
      child: DropdownButton<String>(
        isExpanded: true,
        hint: Text(widget.aliment.unit ?? ''),

        //TODO:NOW: Handle the case when there is null unitSizes.
        items: units
            .map((unit) => DropdownMenuItem(
                value: unit, child: SizedBox(width: 300.0, child: Text(unit))))
            .toList(),
        onChanged: (unit) {
          if (unit != null) {
            setState(() {
              widget.aliment.unit = unit;
            });
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final newKeys = AlimentBank.aliments.keys
    //     // Filter elements in search.
    //     .where(
    //       (id) =>
    //           (searchTerm == '') ||
    //           (AlimentBank.getAliment(id).name
    //               .toLowerCase()
    //               .contains(searchTerm.toLowerCase())),
    //     )
    //     .toList();
    // print(newKeys);
    final Widget? unitSelector = _unitSelector();
    return Scaffold(
      appBar: AppBar(
        title: Text('Editor'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: SizedBox(
              width: 32.0,
              height: 32.0,
              child: Material(
                borderRadius: BorderRadius.circular(8.0),
                clipBehavior: Clip.hardEdge,
                color: Colors.lightGreen,
                child: InkWell(
                  splashColor: Colors.blue,
                  highlightColor: Colors.blue,
                  onTap: () => setState(() {
                    AlimentBankEditor.addNewAliment(context);
                  }),
                  child: Icon(Icons.add_rounded, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _alimentSelector(),
              _inputServed(),
              if (unitSelector != null) unitSelector,
            ],
          ),
        ),
      ),
    );
  }
}
