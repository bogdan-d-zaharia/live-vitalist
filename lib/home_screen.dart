import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/custom_card.dart';

import 'aliment/aliment_bank_provider.dart';
import 'aliment_bank_editor.dart';
import 'day/day.dart';
import 'labels_widget.dart';
import 'meals_journal.dart';
import 'nutrient/nutrient_provider.dart';
import 'nutrient_display.dart';
import 'palette.dart';
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
    Future.microtask(() => ref.read(alimentBankProvider.notifier).load());
  }

  Future<List<Day>> fetchData() async {
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
                  MealsJournal(date: dates.first, day: days.first),
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
