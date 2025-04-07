import 'package:flutter/material.dart';
import 'aliment.dart';
import 'aliment_bank_editor.dart';
import 'cache_handler.dart';
import 'day.dart';
import 'meals_journal.dart';
import 'models/reference_fields_model.dart';
import 'nutrient_display.dart';
import 'nutrients_editor.dart';
import 'permission_handler.dart';
import 'pie_chart.dart';
import 'settings.dart';
import 'week_calendar.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Set<DateTime> dates = {
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
  };

  Future<List<Day>> fetchData() async {
    await PermissionHandler.ensurePermissions(
      [Permission.manageExternalStorage],
      context,
    );

    await NutrientsHandler.load();

    if (AlimentBank.aliments.isEmpty) {
      await AlimentBank.load();
    }

    final List<Day> days = [
      for (final date in dates) (await DayHandler.getDay(date)),
    ];

    return days;
  }

  String calculateStr() {
    /// 29-31 Dec 2024, 1-4 Jan 2025
    final Map<int, Map<int, List<int>>> yearMonthDays = {};
    for (final DateTime date in dates) {
      if (yearMonthDays[date.year] == null) {
        yearMonthDays[date.year] = {};
      }

      if (yearMonthDays[date.year]![date.month] == null) {
        yearMonthDays[date.year]![date.month] = [];
      }

      yearMonthDays[date.year]![date.month]!.add(date.day);
    }

    String str = '';

    void addRange(int year, int month, int firstDay, int lastDay) {
      final String sDays =
          (firstDay == lastDay) ? '$firstDay' : '$firstDay-$lastDay';

      if (str != '') str = '$str, ';
      str = '$str$sDays.$month.$year';
    }

    for (final int mYear in yearMonthDays.keys.toList()..sort()) {
      for (final int mMonth in yearMonthDays[mYear]!.keys.toList()..sort()) {
        final List<int> mDays = yearMonthDays[mYear]![mMonth]!..sort();
        //TODO: Also add visual feedback to the calendar.
        //TODO: Right now, for:
        // ....###........#..###..
        // We get:
        // ....#################..
        // And they should be the same.

        /* At this point, we went trough each year and month in order
         and we got the list of days, in order.
         We will go trough each possible range to add. */
        //// int first = 0;
        //// int last = 0;
        //// for (int i = 1; i <= 31; ++i) {
        ////   if (first == 0 && mDays.contains(i)) first = i;
        ////   if (last == 0 && mDays.contains(i)) last = i;
        //// }
        addRange(mYear, mMonth, mDays.first, mDays.last);
      }
    }

    return str;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<Day> days = snapshot.data!;
          final Day day = days.length == 1 ? days.first : Day.sumDays(days);

          Map<String, double>? distribution;
          Map<String, double>? targetDistribution;

          if ((day.intake['protein'] ?? 0.0) > 0.0 &&
              (day.intake['carbs'] ?? 0.0) > 0.0 &&
              (day.intake['fats'] ?? 0.0) > 0.0) {
            final double total = day.intake['protein']! * 4.0 +
                day.intake['carbs']! * 4.0 +
                day.intake['fats']! * 9.0;

            distribution = {
              'Protein': day.intake['protein']! * 4.0 / total,
              'Carbs': day.intake['carbs']! * 4.0 / total,
              'Fats': day.intake['fats']! * 9.0 / total,
            };

            final double targetTotal = 190.0 * 4.0 + 450.0 * 4.0 + 100.0 * 9.0;

            targetDistribution = {
              'Protein': 190.0 * 4.0 / targetTotal,
              'Carbs': 450.0 * 4.0 / targetTotal,
              'Fats': 100.0 * 9.0 / targetTotal,
            };
          }

          final String str = calculateStr();

          return Scaffold(
            appBar: AppBar(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Micro Health'),
                  Text(
                    str,
                    style: TextStyle(fontSize: 14.0),
                  ),
                ],
              ),
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
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AlimentBankEditor(),
                            ),
                          ).then((value) {
                            setState(() {});
                          });
                        },
                        child: Icon(Icons.table_chart, color: Colors.white),
                      ),
                    ),
                  ),
                ),
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
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NutrientsEditor(),
                            ),
                          ).then((value) {
                            NutrientsHandler.save();
                            setState(() {});
                          });
                        },
                        child: Icon(Icons.list, color: Colors.white),
                      ),
                    ),
                  ),
                ),
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
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Settings(),
                            ),
                          ).then((value) {
                            setState(() {});
                          });
                        },
                        child:
                            Icon(Icons.settings_rounded, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.only(right: 8.0, left: 8.0),
              child: ListView(
                children: [
                  WeekCalendar(
                    onDateChanged: (DateTime newDate) {
                      setState(() {
                        dates = {newDate};
                      });
                    },
                    onDateSelected: (DateTime newDate) {
                      setState(() {
                        dates.add(newDate);
                      });
                    },
                  ),
                  if ((distribution != null) && (targetDistribution != null))
                    PieChart(
                      distribution: distribution,
                      targetDistribution: targetDistribution,
                    ),
                  NutrientDisplay(days: days),
                  MealsJournal(date: dates.first, day: days.first),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          Error.throwWithStackTrace(snapshot.error!, snapshot.stackTrace!);
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
