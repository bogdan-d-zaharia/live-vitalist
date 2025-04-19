import 'package:flutter/material.dart';
import 'aliment.dart';
import 'custom_card.dart';
import 'day.dart';
import 'models/reference_fields_model.dart';
import 'palette.dart';
import 'settings.dart';

class NutrientDisplay extends StatefulWidget {
  const NutrientDisplay({
    required this.days,
    super.key,
  });

  final List<Day> days;

  @override
  State<NutrientDisplay> createState() => _NutrientDisplayState();
}

class _NutrientDisplayState extends State<NutrientDisplay> {
  int category = 0;
  bool isSmartHide = true;

  bool isStarred(String key) {
    return NutrientsHandler.hasTag(key, 'starred');
  }

  //TODO: Perhaps Above lower limit right before above upper limit,
  // so that above upper limit is kept at the end.

  /// **Categories:**
  ///
  /// 0 => Bellow lower limit
  ///
  /// [ DISABLED ] 1 => In-between lower limit and upper limit
  ///
  /// 2 => Bellow upper limit ( there is no lower limit )
  ///
  /// 3 => Above upper limit
  ///
  /// 4 OR -1 => Above lower limit
  ///
  /// 5 OR -2 => There is neither a lower limit nor an upper limit
  int aCat(double intakeA, double? lowerA, double? upperA,
      {bool ascending = false}) {
    int catA = 5;
    if (lowerA != null && intakeA < lowerA) {
      catA = 0;
    } else if (upperA != null) {
      if (intakeA < upperA) {
        /// if (lowerA != null) { catA = 1; } else { catA = 2; }
        catA = 2;
      } else {
        catA = 3;
      }
    } else if (lowerA != null) {
      catA = 4;
    }

    if (ascending) {
      if (catA == 4) catA = -1;
      if (catA == 5) catA = -2;
    }

    return catA;
  }

  @override
  Widget build(BuildContext context) {
    final Day day = Day.sumDays(widget.days);
    final int numDays = widget.days.length;
    List<String> keys = NutrientsHandler.model.keys
        .where((key) => !NutrientsHandler.hasTag(key, 'disabled'))
        .toList();

    /// #region //* SORTING and FILETERING *//

    void sortAscending() {
      /// TODO: Perhaps make something like (ALREADY IN NutrientsHandler `getRatio`)
      /// [0.0, lower]    -> [-1.0, 0.0]
      /// [lower, upper]  -> [0.0, 1.0]
      /// [0.0, upper]    -> [0.0, 1.0]
      /// [upper, inf]    -> [1.0, inf]
      keys.sort(
        (a, b) {
          final double intakeA = (day.intake[a] ?? 0.0) / (numDays);
          final double? lowerA = NutrientsHandler.model[a]!['lowerLimit'];
          final double? upperA = NutrientsHandler.model[a]!['upperLimit'];

          final double intakeB = (day.intake[b] ?? 0.0) / (numDays);
          final double? lowerB = NutrientsHandler.model[b]!['lowerLimit'];
          final double? upperB = NutrientsHandler.model[b]!['upperLimit'];

          final int catA = aCat(intakeA, lowerA, upperA);
          final int catB = aCat(intakeB, lowerB, upperB);

          if (catA != catB) {
            return catA - catB;
          }

          if (catA == 0) {
            final double rA = intakeA / lowerA!;
            final double rB = intakeB / lowerB!;
            return (rA - rB).sign.toInt();
          } else if (catA == 2) {
            final double relativeA = lowerA ?? 0.0;
            final double relativeB = lowerB ?? 0.0;

            final double rA = (intakeA - relativeA) / (upperA! - relativeA);
            final double rB = (intakeB - relativeB) / (upperB! - relativeB);

            return (rA - rB).sign.toInt();
          } else if (catA == 3) {
            final double rA = intakeA / upperA!;
            final double rB = intakeB / upperB!;
            return (rA - rB).sign.toInt();
          } else {
            return 0;
          }
        },
      );
    }

    void sortDescending() {
      keys.sort(
        (a, b) {
          final double intakeA = (day.intake[a] ?? 0.0) / (numDays);
          final double? lowerA = NutrientsHandler.model[a]!['lowerLimit'];
          final double? upperA = NutrientsHandler.model[a]!['upperLimit'];

          final double intakeB = (day.intake[b] ?? 0.0) / (numDays);
          final double? lowerB = NutrientsHandler.model[b]!['lowerLimit'];
          final double? upperB = NutrientsHandler.model[b]!['upperLimit'];

          final int catA = aCat(intakeA, lowerA, upperA, ascending: true);
          final int catB = aCat(intakeB, lowerB, upperB, ascending: true);

          if (catA != catB) {
            return -(catA - catB);
          }

          if (catA == 3) {
            final double rA = intakeA / upperA!;
            final double rB = intakeB / upperB!;
            return -(rA - rB).sign.toInt();
          } else if (catA == 2) {
            final double relativeA = lowerA ?? 0.0;
            final double relativeB = lowerB ?? 0.0;

            final double rA = (intakeA - relativeA) / (upperA! - relativeA);
            final double rB = (intakeB - relativeB) / (upperB! - relativeB);

            return -(rA - rB).sign.toInt();
          } else if (catA == 0 || catA == -1) {
            final double rA = intakeA / lowerA!;
            final double rB = intakeB / lowerB!;
            return -(rA - rB).sign.toInt();
          } else {
            return 0;
          }
        },
      );
    }

    void smartHide() {
      keys = keys.where((key) {
        if (isStarred(key)) return true;

        final double intake = (day.intake[key] ?? 0.0) / (numDays);
        final double? lower = NutrientsHandler.model[key]!['lowerLimit'];
        final double? upper = NutrientsHandler.model[key]!['upperLimit'];

        final bool isDeficit = (lower != null && intake < lower);
        final bool isSurplus = (upper != null && intake > 0.9 * upper);

        return isDeficit || isSurplus;
      }).toList();
    }

    /// #endregion //* SORTING and FILETERING *//

    if (isSmartHide) smartHide();
    if (category == 1) {
      keys = keys.where(isStarred).toList();
    } else if (category == 2) {
      sortDescending();
    } else if (category == 3) {
      sortAscending();
    }

    final List<Widget> elements = [];

    for (var key in keys) {
      final String label =
          NutrientsHandler.model[key]!['translations'][SettingsData.language];
      final String unit = NutrientsHandler.model[key]!['unit'];
      final double intake = (day.intake[key] ?? 0.0) / (numDays);
      final double? lower = NutrientsHandler.model[key]!['lowerLimit'];
      final double? upper = NutrientsHandler.model[key]!['upperLimit'];

      final Map<Aliment, double> topIntakeAliments = day
          .topIntakeAliments(key)
          .map((key, value) => MapEntry(key, value / (numDays)));

      elements.add(
        Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: MiniCard(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              SizedBox(height: 40.0),
                              Text(
                                  '$label intake: ${intake.toStringAsFixed(3)}',
                                  style: TextStyle(fontSize: 24.0)),
                              if (lower != null)
                                Text(
                                    'Lower limit: ${lower.toStringAsFixed(3)}'),
                              if (upper != null)
                                Text(
                                    'Upper limit: ${upper.toStringAsFixed(3)}'),
                              Divider(height: 36.0),
                              Text('Top sources of ${label.toLowerCase()}:',
                                  style: TextStyle(fontSize: 24.0)),
                              ...topIntakeAliments.entries.map((e) {
                                /// eg. Cheese
                                final String name = e.key.getAliment.name;

                                /// eg. protein
                                final String valueOfLabel =
                                    '(${e.value.toStringAsFixed(3)} ${label.toLowerCase()})';

                                return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('$name $valueOfLabel'));
                              }),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 2.0,
                bottom: 6.0,
                top: 6.0,
              ),
              child: NutrientBar(
                label: label,
                unit: unit,
                amount: intake,
                lowerLimit: lower,
                upperLimit: upper,
                icon: NutrientsHandler.tagsToWidgets(
                        NutrientsHandler.getTags(key))
                    .firstOrNull,
              ),
            ),
          ),
        ),
      );
    }

    final Widget divider = Divider(
      color: Colors.black.withValues(alpha: 0.1),
      thickness: 0.5,
      height: 0.0,
    );
    for (int i = elements.length - 1; i > 0; i--) {
      elements.insert(i, divider);
    }

    return CustomCard(
      logo: const Icon(Icons.bar_chart_rounded),
      title: 'Nutrients',
      action: DropdownButton<int>(
        value: category,
        items: [
          DropdownMenuItem(
            value: -1,
            child: Row(
              children: [
                Checkbox(
                    value: isSmartHide,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          isSmartHide = value;
                        });
                      }
                    }),
                Icon(Icons.deselect_rounded),
                SizedBox(width: 4.0),
                Text('Smart Hiding'),
              ],
            ),
          ),
          DropdownMenuItem(
              value: 0,
              child: Row(
                children: [
                  Icon(Icons.select_all_rounded),
                  SizedBox(width: 4.0),
                  Text('All'),
                ],
              )),
          DropdownMenuItem(
            value: 1,
            child: Row(
              children: [
                Icon(Icons.star_rounded),
                SizedBox(width: 4.0),
                Text('Starred'),
              ],
            ),
          ),
          DropdownMenuItem(
            value: 2,
            child: Row(
              children: [
                Icon(Icons.keyboard_arrow_down_rounded),
                SizedBox(width: 4.0),
                Text('Descending'),
              ],
            ),
          ),
          DropdownMenuItem(
            value: 3,
            child: Row(
              children: [
                Icon(Icons.keyboard_arrow_up_rounded),
                SizedBox(width: 4.0),
                Text('Ascending'),
              ],
            ),
          ),
        ],
        onChanged: (value) {
          if (value != null) {
            setState(() {
              if (value != -1) {
                category = value;
              } else {
                isSmartHide = !isSmartHide;
              }
            });
          }
        },
      ),
      child: Column(
        children: [
          const SizedBox(height: 6.0),
          ...elements.map((e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: e,
              ))
        ],
      ),
    );
  }
}

class NutrientBar extends StatelessWidget {
  const NutrientBar({
    required this.label,
    required this.unit,
    required this.amount,
    this.lowerLimit,
    this.upperLimit,
    this.icon,
    super.key,
  });

  final String label;
  final String unit;
  final double amount;
  final double? lowerLimit;
  final double? upperLimit;
  final Widget? icon;

  /// $1 is Right, $2 is Left.
  (String?, String?) calculateRLExcessTexts({int charSpacing = 2}) {
    ///! WARNING: Wizzardry
    final String spacing = String.fromCharCodes(
        List.generate(charSpacing, (i) => ' '.codeUnitAt(0)));

    double? absoluteExcess;

    if ((lowerLimit != null) && (amount < lowerLimit!)) {
      absoluteExcess = amount - lowerLimit!;
    } else if ((upperLimit != null) && (amount > upperLimit!)) {
      absoluteExcess = amount - upperLimit!;
    }

    double? relativeExcess;

    if ((lowerLimit != null) && (amount < lowerLimit!)) {
      relativeExcess = absoluteExcess! / lowerLimit!;
    } else if ((upperLimit != null) && (amount > upperLimit!)) {
      relativeExcess = absoluteExcess! / upperLimit!;
    }

    double? remaining;

    if (absoluteExcess == null && upperLimit != null) {
      remaining = upperLimit! - amount;
    }

    String? rightText;
    if (absoluteExcess != null) {
      rightText =
          '${absoluteExcess > 0 ? '+' : ''}${absoluteExcess.toStringAsFixed(1)} $unit$spacing';
    }
    if (remaining != null) {
      rightText = '${(remaining).toStringAsFixed(2)} $unit$spacing';
    }

    String? leftText;
    if (relativeExcess != null) {
      leftText =
          '$spacing${relativeExcess > 0 ? '+' : ''}${(relativeExcess * 100.0).toStringAsFixed(1)}%';
    }

    /// TODO: Maybe 0% -> 'lowerLimit'; 100% -> 'upperLimit'
    /// if (remaining != null) {
    ///   leftText = '${(remaining).toStringAsFixed(2)} $unit ';
    /// }

    (String?, String?) output = (rightText, leftText);

    return output;
  }

  Widget _bar1({double height = 15.0, double radius = 5.0}) {
    if (lowerLimit == null && upperLimit == null) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.grey,
        ),
        height: 15.0,
      );
    } else {
      final double top = (upperLimit ?? lowerLimit!) * 1.5;
      final (String? rightText, String? leftText) = calculateRLExcessTexts();

      /// TODO: Make reach corners round.
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: Colors.orange,
        ),
        clipBehavior: Clip.antiAlias,
        height: height,
        child: Stack(
          alignment: Alignment.topLeft,
          fit: StackFit.expand,
          children: [
            FractionallySizedBox(
              alignment: Alignment.topLeft,
              widthFactor: (upperLimit ?? top) / top,
              child: Container(color: Colors.green),
            ),
            FractionallySizedBox(
              alignment: Alignment.topLeft,
              widthFactor: (lowerLimit ?? 0.0) / top,
              child: Container(color: Colors.lightGreen),
            ),
            FractionallySizedBox(
              alignment: Alignment.topRight,
              widthFactor: 1.0 - (amount.clamp(0.0, top) / top),
              child: Container(color: Colors.white.withValues(alpha: 0.7)),
            ),
            if (rightText != null)
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  rightText,
                  style: Palette.dayViewRegular.copyWith(
                    fontSize: 12.0,
                    color: Colors.black.withValues(alpha: 0.6),
                  ),
                ),
              ),
            if (leftText != null)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  leftText,
                  style: Palette.dayViewRegular.copyWith(
                    fontSize: 12.0,
                    color: Colors.black.withValues(alpha: 0.6),
                  ),
                ),
              ),
          ],
        ),
      );
    }
  }

  Widget _bar2() {
    if (lowerLimit == null && upperLimit == null) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.grey,
        ),
        height: 15.0,
      );
    } else {
      final double top = (upperLimit ?? lowerLimit!);
      final (String? rightText, String? leftText) = calculateRLExcessTexts();

      /// TODO: Make reach corners round.
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.green,
        ),
        clipBehavior: Clip.antiAlias,
        height: 15.0,
        child: Stack(
          alignment: Alignment.topLeft,
          fit: StackFit.expand,
          children: [
            FractionallySizedBox(
              alignment: Alignment.topLeft,
              widthFactor: (lowerLimit ?? 0.0) / top,
              child: Container(color: Colors.lightGreen),
            ),
            FractionallySizedBox(
              alignment: Alignment.topRight,
              widthFactor: 1.0 - (amount.clamp(0.0, top) / top),
              child: Container(color: Colors.white.withValues(alpha: 0.7)),
            ),
            if (upperLimit != null)
              FractionallySizedBox(
                alignment: Alignment.topLeft,
                widthFactor: (amount - top).clamp(0.0, top) / top,
                child: Container(color: Colors.orange),
              ),
            if (rightText != null)
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  rightText,
                  style: Palette.dayViewRegular.copyWith(
                    fontSize: 12.0,
                    color: Colors.black.withValues(alpha: 0.6),
                  ),
                ),
              ),
            if (leftText != null)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  leftText,
                  style: Palette.dayViewRegular.copyWith(
                    fontSize: 12.0,
                    color: Colors.black.withValues(alpha: 0.6),
                  ),
                ),
              ),
          ],
        ),
      );
    }
  }

  Widget _var1() {
    return Row(
      children: [
        SizedBox(
            width: 100.0,
            child: Text(label, style: TextStyle(letterSpacing: -0.0))),
        SizedBox(width: 5.0),
        Expanded(child: _bar1()),
        SizedBox(width: 5.0),
        SizedBox(
          width: 80.0,
          child: Text('${amount.toStringAsFixed(2)} $unit',
              style: TextStyle(letterSpacing: -0.0)),
        ),
      ],
    );
  }

  Widget _var2() {
    final String? prefix = lowerLimit?.toStringAsFixed(2);
    final String? suffix = upperLimit?.toStringAsFixed(2);

    return Column(
      children: [
        Text(label, style: TextStyle(letterSpacing: -0.0)),
        SizedBox(height: 5.0),
        _bar1(),
        SizedBox(height: 5.0),
        Stack(
          children: [
            if (prefix != null)
              Positioned(
                  left: 10.0,
                  child: Text(prefix, style: TextStyle(letterSpacing: -0.0))),
            Center(
              child: Text('${amount.toStringAsFixed(2)} $unit',
                  style: TextStyle(letterSpacing: -0.0)),
            ),
            if (suffix != null)
              Positioned(
                  right: 10.0,
                  child: Text(suffix, style: TextStyle(letterSpacing: -0.0))),
          ],
        ),
      ],
    );
  }

  Widget _bar2_5(
      {double height = 15.0, double radius = 5.0, double fontSize = 12.0}) {
    if (lowerLimit == null && upperLimit == null) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.grey,
        ),
        height: 15.0,
      );
    } else {
      final double top = (upperLimit ?? lowerLimit!) * 1.5;
      final (String? rightText, String? leftText) =
          calculateRLExcessTexts(charSpacing: 3);

      /// TODO: Make reach corners round.
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: Colors.orange,
        ),
        clipBehavior: Clip.antiAlias,
        height: height,
        child: Stack(
          alignment: Alignment.topLeft,
          fit: StackFit.expand,
          children: [
            FractionallySizedBox(
              alignment: Alignment.topLeft,
              widthFactor: (upperLimit ?? top) / top,
              child: Container(color: Colors.green),
            ),
            FractionallySizedBox(
              alignment: Alignment.topLeft,
              widthFactor: (lowerLimit ?? 0.0) / top,
              child: Container(color: Colors.lightGreen),
            ),
            FractionallySizedBox(
              alignment: Alignment.topRight,
              widthFactor: 1.0 - (amount.clamp(0.0, top) / top),
              child: Container(color: Colors.white.withValues(alpha: 0.7)),
            ),
            if (rightText != null)
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  rightText,
                  style: Palette.dayViewRegular.copyWith(
                    fontSize: fontSize,
                    color: Colors.black.withValues(alpha: 0.6),
                  ),
                ),
              ),
            if (leftText != null)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  leftText,
                  style: Palette.dayViewRegular.copyWith(
                    fontSize: fontSize,
                    color: Colors.black.withValues(alpha: 0.6),
                  ),
                ),
              ),
          ],
        ),
      );
    }
  }

  Widget _var2_5() {
    return Column(
      children: [
        Row(
          children: [
            ...NutrientsHandler.widMajorMinorLabels(label),
            if (icon != null) icon!,
            if (icon != null) SizedBox(width: 4.0),
            Spacer(),
            Center(
              child: Text('${amount.toStringAsFixed(2)} $unit',
                  style: TextStyle(letterSpacing: -0.0)),
            ),
          ],
        ),
        SizedBox(height: 5.0),
        _bar2_5(height: 12.0, radius: 6.0, fontSize: 11.0),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _var2_5();
  }
}
