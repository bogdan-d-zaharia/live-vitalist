import 'dart:convert';

import 'package:flutter/material.dart';
import 'aliment.dart';
import 'aliment_bank_editor.dart';
import 'cache_handler.dart';
import 'day.dart';
import 'meals_journal.dart';
import 'models/reference_fields_model.dart';
import 'notification_handler.dart';
import 'nutrient_display.dart';
// import 'nutrients_chart.dart';
import 'permission_handler.dart';
import 'pie_chart.dart';
import 'settings.dart';
import 'string_input.dart';
import 'week_calendar.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:intl/intl.dart' as intl;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationHandler.initialize();

  /// Initialize notifications

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          // brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const ScaffoldPage(),
    );
  }
}

class ScaffoldPage extends StatefulWidget {
  const ScaffoldPage({super.key});

  @override
  State<ScaffoldPage> createState() => _ScaffoldPageState();
}

class _ScaffoldPageState extends State<ScaffoldPage> {
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

          if (day.intake.containsKey('protein') &&
              day.intake.containsKey('carbs') &&
              day.intake.containsKey('fats')) {
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
          ////return Placeholder();
          throw Exception(snapshot.hasError ? snapshot.error.toString() : '');

          ////return Scaffold(
          ////  body: Center(
          ////    child: Text(snapshot.error.toString()),
          ////  ),
          ////);
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

class NutrientsEditor extends StatefulWidget {
  const NutrientsEditor({super.key});

  @override
  State<NutrientsEditor> createState() => _NutrientsEditorState();
}

class _NutrientsEditorState extends State<NutrientsEditor> {
  late String newJsonString;

  bool isJson = false;

  Widget _buildJson() {
    return JsonEditor(
      initString: newJsonString,
      update: (p0) {
        final json = jsonDecode(p0);
        NutrientsHandler.fromJson(json);
        Navigator.pop(context);
      },
    );
  }

  Widget _build() {
    final Widget divider = Divider(
      color: Colors.black.withValues(alpha: 0.1),
      thickness: 0.5,
      height: 50.0,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: ListView.builder(
        itemCount: 2 * NutrientsHandler.toJson().length - 1,
        itemBuilder: (context, index) {
          if (index % 2 != 0) {
            return divider;
          } else {
            final idx = index ~/ 2;
            final e = NutrientsHandler.toJson().entries.elementAt(idx);
            return Column(
              children: [
                StringInput(hint: 'Key', initString: e.key),
                StringInput(hint: 'Unit', initString: e.value['unit']),
                StringInput(
                    hint: 'Lower limit',
                    initString: e.value['lowerLimit']?.toString()),
                StringInput(
                    hint: 'Upper limit',
                    initString: e.value['upperLimit']?.toString()),
              ],
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    newJsonString =
        JsonEncoder.withIndent('  ').convert(NutrientsHandler.toJson());

    return Scaffold(
        appBar: AppBar(
          title: Text('Nutrients Editor'),
          actions: [
            Switch(
              value: isJson,
              onChanged: (_) => setState(() => isJson = !isJson),
            ),
          ],
        ),
        body: (!isJson) ? _build() : _buildJson());
  }
}
