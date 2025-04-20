import 'package:flutter/material.dart';
import 'aliment.dart';
import 'aliment_bank_editor.dart';
import 'cache_handler.dart';
import 'day.dart';
import 'meals_journal.dart';
import 'models/reference_fields_model.dart';
import 'nutrient_display.dart';
import 'nutrients_editor.dart';
import 'pie_chart.dart';
import 'settings.dart';
import 'week_calendar.dart';

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
    await NutrientsHandler.load();

    //TODO: Study if this `if` is needed.
    if (AlimentBank.aliments.isEmpty) {
      await AlimentBank.load();
    }

    final List<Day> days = [
      for (final date in dates) (await DayHandler.getDay(date)),
    ];

    return days;
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

          return Scaffold(
            appBar: AppBar(
              title: Text('Live Vitalist'),
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
                            setState(() {}); //TODO: Doesn't work
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
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListView(
                children: [
                  WeekCalendar(
                    dates: dates,
                    refresh: () => setState(() {}),
                  ),
                  if ((distribution != null) && (targetDistribution != null))
                    PieChart(
                      distribution: distribution,
                      targetDistribution: targetDistribution,
                    ),
                  MealsJournal(
                    date: dates.first,
                    day: days.first,
                    refresh: () => setState(() {}),
                  ),
                  NutrientDisplay(days: days),
                  SizedBox(height: 12.0),
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
