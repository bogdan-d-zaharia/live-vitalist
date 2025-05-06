import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/custom_card.dart';
// import 'package:fl_chart/fl_chart.dart' as flc;

import 'aliment.dart';
import 'aliment_bank_editor.dart';
import 'cache_handler.dart';
import 'day.dart';
import 'labels_widget.dart';
import 'meals_journal.dart';
import 'nutrient/nutrient_provider.dart';
import 'nutrient_display.dart';
import 'palette.dart';
import 'pie_chart.dart';
import 'settings.dart';
import 'week_calendar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Set<DateTime> dates = {
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
  };

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(nutrientStateProvider.notifier).load());
  }

  Future<List<Day>> fetchData() async {
    //TODO: Study if this `if` is needed.
    if (AlimentBank.aliments.isEmpty) {
      await AlimentBank.load();
    }

    final List<Day> days = [
      for (final date in dates) (await DayHandler.getDay(date)),
    ];

    return days;
  }

  Widget bar(List<Map<String, dynamic>> l,
      {double height = 12.0, double radius = 7.0, double fontSize = 11.0}) {
    final double total =
        l.map((e) => e['value'] as double).fold(0.0, (a, b) => a + b);
    if (total == 0.0) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.grey,
        ),
        height: height,
      );
    } else {
      return Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(radius)),
        clipBehavior: Clip.antiAlias,
        height: height,
        child: Row(
          children: l
              .map(
                (e) => Expanded(
                  flex: ((e['value'] as double) * 1000.0).round(),
                  child: Container(
                    color: e['color'],
                    child: Center(
                      child: Text(
                        '${(e['value'] * 100.0 / total as double).toStringAsFixed(0)}%',
                        style: Palette.dayViewRegular.copyWith(
                          fontSize: fontSize,
                          color: Colors.black.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      );
    }
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
                  padding: const EdgeInsets.only(right: 12.0),
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
                        child: Icon(
                          Icons.menu_book_rounded,
                          color: Colors.white,
                        ),
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
                  CustomCard(
                    logo: Icon(Icons.stacked_bar_chart_rounded),
                    title: 'Ratios',
                    child: Column(
                      children: [
                        Row(
                            children: LabelsWidget.labels({
                          "Carbs": Palette.carbBlue,
                          "Fats": Palette.fatYellow,
                          "Protein": Palette.proteinRed,
                        }).map((e) => Flexible(child: e)).toList()),
                        bar([
                          {
                            "text": "carbs",
                            "value": (day.intake['carbs'] ?? 0.0) * 4.0,
                            "color": Palette.carbBlue,
                          },
                          {
                            "text": "fats",
                            "value": (day.intake['fats'] ?? 0.0) * 9.0,
                            "color": Palette.fatYellow,
                          },
                          {
                            "text": "protein",
                            "value": (day.intake['protein'] ?? 0.0) * 4.0,
                            "color": Palette.proteinRed,
                          },
                        ]),
                        SizedBox(height: 24.0),
                        Row(
                            children: LabelsWidget.labels({
                          "Omega-3": Colors.orange,
                          "Omega-6": Colors.purple,
                        }).map((e) => Flexible(child: e)).toList()),
                        bar([
                          {
                            "text": "Omega-3",
                            "value": day.intake['omega3'] ?? 0.0,
                            "color": Colors.orange,
                          },
                          {
                            "text": "Omega-6",
                            "value": day.intake['omega6'] ?? 0.0,
                            "color": Colors.purple,
                          },
                        ]),
                      ],
                    ),
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
                  NutrientDisplay(
                    days: days,
                    refresh: () => setState(() {}),
                  ),
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
              child: CircularProgressIndicator(strokeCap: StrokeCap.round),
            ),
          );
        }
      },
    );
  }
}
