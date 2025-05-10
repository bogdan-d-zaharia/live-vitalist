import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'aliment/aliment_bank_provider.dart';
import 'aliment_bank_editor.dart';
import 'day/day.dart';
import 'day/day_provider.dart';
import 'meals_journal.dart';
import 'nutrient/nutrient_provider.dart';
import 'settings.dart';

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

  Widget _build(List<Day> days) {
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
            MealsJournal(),
            SizedBox(height: 12.0),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(selectedDaysProvider).when(
          data: _build,
          error: (error, stackTrace) =>
              Error.throwWithStackTrace(error, stackTrace),
          loading: () => Scaffold(
            body: Center(
              child: CircularProgressIndicator(strokeCap: StrokeCap.round),
            ),
          ),
        );
  }
}
