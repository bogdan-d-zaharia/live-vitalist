import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import 'cache_handler.dart';
import 'custom_card.dart';
import 'icon_button.dart';
import 'models/reference_fields_model.dart';
import 'palette.dart';
import 'settings.dart';

const double itemHeight = 80.0;
const double labelHeight = 26.0;

class DottedLine extends StatelessWidget {
  const DottedLine({
    required this.dotDiameter,
    required this.dotSpacing,
    required this.color,
    super.key,
  });

  final double dotDiameter;
  final double dotSpacing;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: dotDiameter,
      child: CustomPaint(
        size: Size(1000.0, 100.0),
        painter: DottedLinePainter(
          dotDiameter: dotDiameter,
          dotSpacing: dotSpacing,
          color: color,
        ),
      ),
    );
  }
}

class DottedLinePainter extends CustomPainter {
  const DottedLinePainter({
    required this.dotDiameter,
    required this.dotSpacing,
    required this.color,
  });

  final double dotDiameter;
  final double dotSpacing;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    for (double i = 0.0; i < size.width; i += dotDiameter + dotSpacing) {
      canvas.drawCircle(Offset(i, dotDiameter / 2.0), dotDiameter / 2.0, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class WeekCalendar extends StatelessWidget {
  const WeekCalendar({
    required this.dates,
    required this.refresh,
    super.key,
  });

  final Set<DateTime> dates;
  final void Function() refresh;

  void showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: CustomCard(
            title: 'Help',
            child: Container(color: Colors.blue),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final DateTime tNow = DateTime.now();
    final DateTime now = DateTime(tNow.year, tNow.month, tNow.day);

    return CustomCard(
      logo: const Icon(Icons.view_week),
      title: "Week Calendar",
      action: MyIconButton(
        icon: Icon(Icons.help_outline_rounded),
        onTap: () => showHelp(context),
      ),
      child: SizedBox(
        /* Used trial and error to find a good height; */
        //TODO: perhaps use a more programmatical approach.
        height: itemHeight,
        child: Stack(
          children: [
            ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              reverse: true,
              itemBuilder: (context, index) {
                final DateTime date = now.subtract(Duration(days: index));
                return Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8.0),
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    onTap: () {
                      dates.clear();
                      dates.add(date);
                      refresh();
                    },
                    onLongPress: () {
                      if (!dates.contains(date)) {
                        dates.add(date);
                      } else if (dates.length > 1) {
                        dates.remove(date);
                      }
                      refresh();
                    },
                    //TODO: Is slowing down single tap
                    // onDoubleTap: () {
                    //   DateTime latest = dates.first;
                    //   for (DateTime d in dates) {
                    //     if (latest.compareTo(d) < 0) {
                    //       latest = d;
                    //     }
                    //   }

                    //   for (var i = 0; i < latest.difference(date).inDays; i++) {
                    //     dates.add(latest.subtract(Duration(days: i + 1)));
                    //   }
                    //   refresh();
                    // },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6.0,
                      ),
                      child: CalendarItem(
                        date: date,
                        title: intl.DateFormat(
                                SettingsData.isMonthDay ? 'M/d' : 'd/M')
                            .format(date),
                        isSelected: dates.contains(date),
                      ),
                    ),
                  ),
                );
              },
            ),
            Positioned(
              /// Dotted line position
              /// HEIGHT_TEXT + f do* (HEIGHT - HEIGHT_TEXT) - dotDiameter / 2.0
              bottom: labelHeight +
                  1.0 / 1.5 * (itemHeight - labelHeight) -
                  1.25 / 2.0,
              child: DottedLine(
                  dotDiameter: 1.25, dotSpacing: 2.25, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}

class CalendarItem extends StatelessWidget {
  /// Date guarded by extension.
  const CalendarItem({
    super.key,
    required this.title,
    required this.date,
    required this.isSelected,
  });

  final String title;
  final DateTime date;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DayHandler.getDay(date),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return wid(snapshot.data!.intake, context);
        } else if (snapshot.hasError) {
          //TODO: Replace with a reload button, perhaps.
          Error.throwWithStackTrace(snapshot.error!, snapshot.stackTrace!);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  (double?, double?, double?) calculateMinMaxAverage(
      Map<String, double> values) {
    double min = double.infinity;
    double max = 0.0;
    double sum = 0.0;
    int num = 0;

    for (final key in values.keys) {
      final double? lower = NutrientsHandler.model[key]!['lowerLimit'];
      final double? upper = NutrientsHandler.model[key]!['upperLimit'];
      final double? ratio =
          NutrientsHandler.getRatio(values[key]!, lower, upper, true);

      if (ratio != null) {
        if (ratio < min) min = ratio;
        if (ratio > max) max = ratio;
        sum += ratio;
        num++;
      }
    }

    if (num == 0 || min == double.infinity || max == 0.0) {
      return (null, null, null);
    }

    return (min, max, sum / num);
  }

  (double, double, double) forceMinMaxAverage(Map<String, double> values) {
    var (double? minim, double? maxim, double? average) =
        calculateMinMaxAverage(values);
    return (minim ?? 0.0, maxim ?? 0.0, average ?? 0.0);
  }

  Widget wid(Map<String, double> values, BuildContext context) {
    late Widget? bars;
    if (values.values.every((element) => element == 0.0)) {
      bars = null;
    } else {
      final (double minim, double maxim, double average) =
          forceMinMaxAverage(values);

      final double? kcalRatio = NutrientsHandler.getRatio(
          values['kcals'],
          NutrientsHandler.model['kcals']?['lowerLimit'],
          NutrientsHandler.model['kcals']?['upperLimit'],
          true);

      bars = Container(
        margin: EdgeInsets.only(bottom: labelHeight),
        width: 12.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
        ),
        clipBehavior: Clip.hardEdge,
        child: !SettingsData.isComplexCalendar
            ? FractionallySizedBox(
                heightFactor: (kcalRatio ?? 0 / 1.5).clamp(0.0, 1.0),
                child: Container(color: Colors.lightGreen),
              )
            : Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  FractionallySizedBox(
                    heightFactor: (maxim / 1.5).clamp(0.0, 1.0),
                    child: Container(
                        color: Colors.lightGreen.withValues(alpha: 0.4)),
                  ),
                  FractionallySizedBox(
                    heightFactor: ((kcalRatio ?? 0.0) / 1.5).clamp(0.0, 1.0),
                    child: Container(color: Colors.lightGreen),
                  ),
                  FractionallySizedBox(
                    heightFactor: (minim / 1.5).clamp(0.0, 1.0),
                    child: Container(color: Colors.green),
                  ),
                ],
              ),
      );
    }
    Widget wid = SizedBox(
      width: 36.0,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          if (bars != null) bars,
          Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: Text(
              title,
              style: switch (isSelected) {
                false => Palette.calendarItem
                    .copyWith(color: Colors.grey.withValues(alpha: 0.8)),
                true => Palette.calendarItem.copyWith(
                    color: (Palette.isDarkMode(context)
                        ? Colors.white
                        : Colors.black),
                    shadows: [
                      Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 12.0,
                        color: (Palette.isDarkMode(context)
                            ? Colors.white.withValues(alpha: 0.6)
                            : Colors.black.withValues(alpha: 0.4)),
                      ),
                    ],
                  ),
              },
            ),
          ),
        ],
      ),
    );

    return wid;
  }
}

//TODO: Implement
// class DeprecatedCalendarItem extends StatelessWidget {
//   const DeprecatedCalendarItem({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }

// class ComplexCalendarItem extends StatelessWidget {
//   const ComplexCalendarItem({
//     required this.minim,
//     required this.maxim,
//     required this.average,
//     required this.kcalRatio,
//     super.key,
//   });

//   final double minim;
//   final double maxim;
//   final double average;
//   final double kcalRatio;

//   @override
//   Widget build(BuildContext context) {
//     /// kcalIndicatorHeight
//     const double kIH = 4.0;

//     return Stack(
//       alignment: Alignment.bottomCenter,
//       children: [
//         ClipRRect(
//           borderRadius: BorderRadius.circular(6.0),
//           clipBehavior: Clip.hardEdge,
//           child: Stack(
//             alignment: Alignment.bottomCenter,
//             children: [
//               //TODO: Study and implement showing it simplified, by a single field.
//               FractionallySizedBox(
//                 heightFactor: (maxim / 1.5).clamp(0.0, 1.0),
//                 child: Container(
//                   color: Colors.lightGreen.withValues(alpha: 0.4),
//                 ),
//               ),
//               FractionallySizedBox(
//                 heightFactor: (average / 1.5).clamp(0.0, 1.0),
//                 child: Container(
//                   color: Colors.lightGreen.withValues(alpha: 0.4),
//                 ),
//               ),
//               FractionallySizedBox(
//                 heightFactor: (minim / 1.5).clamp(0.0, 1.0),
//                 child: Container(
//                   color: Colors.lightGreen,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Positioned(
//           /// Dot position
//           bottom: labelHeight +
//               kcalRatio / 1.5 * (itemHeight - labelHeight) -
//               kIH / 2.0,
//           child: Container(
//             height: kIH,
//             width: kIH,
//             decoration: BoxDecoration(
//               color: Colors.green,
//               borderRadius: BorderRadius.circular(kIH / 2.0),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
