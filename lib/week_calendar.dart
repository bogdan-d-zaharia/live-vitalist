import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:micro_health_0_0_7/models/reference_fields_model.dart';

import 'cache_handler.dart';
import 'custom_card.dart';
import 'palette.dart';
import 'settings.dart';

const double itemHeight = 80.0;
const double labelHeight = 24.0;

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

      /// canvas.drawRect(
      ///   Rect.fromLTWH(i, 0.0, dotDiameter, dotDiameter),
      ///   paint,
      /// );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// class DottedLine extends StatelessWidget {
//   const DottedLine({
//     required this.dotDiameter,
//     required this.dotSpacing,
//     required this.color,
//     super.key,
//   });

//   final double dotDiameter;
//   final double dotSpacing;
//   final Color color;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 10.0,
//       child: ListView.builder(
//         controller: ,
//         scrollDirection: Axis.horizontal,
//         itemBuilder: (context, index) {
//           if (index % 2 == 0) {
//             return Container(
//               width: dotDiameter,
//               height: dotDiameter,
//               // decoration: BoxDecoration(
//               color: color,
//               //   borderRadius: BorderRadius.circular(dotDiameter / 2.0),
//               // ),
//             );
//           }
//           return SizedBox(width: dotSpacing);
//         },
//       ),
//     );
//   }
// }

class WeekCalendar extends StatelessWidget {
  const WeekCalendar({
    required this.onDateChanged,
    required this.onDateSelected,
    super.key,
  });

  final void Function(DateTime) onDateChanged;
  final void Function(DateTime) onDateSelected;

  @override
  Widget build(BuildContext context) {
    final DateTime tNow = DateTime.now();
    final DateTime now = DateTime(tNow.year, tNow.month, tNow.day);

    return CustomCard(
      logo: const Icon(Icons.view_week),
      title: "Week Calendar",
      child: SizedBox(
        // Used trial and error to find a good height;
        // TODO: perhaps use a more programmatical approach.
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
                    onTap: () => onDateChanged(date),
                    onLongPress: () => onDateSelected(date),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6.0,
                        // vertical: 8.0,
                      ),
                      child: CalendarItem(
                          date: date,
                          title: intl.DateFormat(
                                  SettingsData.isMonthDay ? 'M/d' : 'd/M')
                              .format(date)

                          // intl.DateFormat('EEE')
                          //     // .format(day.add(Duration(days: index - 6)))
                          //     .format(date)
                          //     .toLowerCase(),
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
  });

  final String title;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DayHandler.getDay(date),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return wid(snapshot.data!.intake, context);
        } else if (snapshot.hasError) {
          // TODO: Replace with a reload button, perhaps.
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
    values = Map.from(values)
      ..removeWhere((key, value) => NutrientsHandler.hasTag(key, 'disabled'));
    final (double minim, double maxim, double average) =
        forceMinMaxAverage(values);

    final double? kcalRatio = NutrientsHandler.getRatio(
        values['kcals'],
        NutrientsHandler.model['kcals']?['lowerLimit'],
        NutrientsHandler.model['kcals']?['upperLimit'],
        false);

    /// kcalIndicatorHeight
    const double kIH = 4.0;

    return SizedBox(
      width: 36.0,
      // height: 54.0,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: labelHeight),
            width: 12.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0),
            ),
            clipBehavior: Clip.hardEdge,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                FractionallySizedBox(
                  heightFactor: (maxim / 1.5).clamp(0.0, 1.0),
                  child: Container(
                    color: Palette.green.withValues(alpha: 0.5),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: (average / 1.5).clamp(0.0, 1.0),
                  child: Container(
                    color: Palette.green.withValues(alpha: 0.8),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: (minim / 1.5).clamp(0.0, 1.0),
                  child: Container(
                    color: Colors.green.withValues(alpha: 0.4),
                  ),

                  // child: Container(
                  //   decoration: const BoxDecoration(
                  //     gradient: LinearGradient(
                  //       colors: Palette.greenGradientColors,
                  //       begin: Alignment.topCenter,
                  //       end: Alignment.bottomCenter,
                  //     ),
                  //   ),
                  // ),
                ),
              ],
            ),
          ),
          if (kcalRatio != null)
            Positioned(
              /// Dot position
              bottom: labelHeight +
                  kcalRatio / 1.5 * (itemHeight - labelHeight) -
                  kIH / 2.0,
              child: Container(
                height: kIH,
                width: kIH,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(kIH / 2.0),
                ),
              ),
            ),
          Text(title, style: Palette.calendarItem),
        ],
      ),
    );
  }
}
