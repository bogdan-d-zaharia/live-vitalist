import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'aliment/aliment_bank_provider.dart';
import 'meals_journal.dart';
import 'nutrient/nutrient_provider.dart';
import 'nutrient_display.dart';
import 'settings.dart';
import 'week_calendar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(nutrientStateProvider.notifier).load());
    Future.microtask(() => ref.read(alimentBankProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
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
                        builder: (context) => Settings(),
                      ),
                    ).then((value) {
                      setState(() {});
                    });
                  },
                  child: Icon(Icons.settings_rounded, color: Colors.white),
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
            WeekCalendar(),
            MealsJournal(),
            NutrientDisplay(),
            SizedBox(height: 12.0),
          ],
        ),
      ),
    );
  }
}
