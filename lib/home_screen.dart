import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/features/calendar/calendar.dart';
import 'package:live_vitalist/features/meals_journal/meals_journal.dart';
import 'package:live_vitalist/features/nutrient_display/nutrient_display.dart';
import 'package:live_vitalist/features/ratio_bars/ratio_bars_card.dart';
import 'package:live_vitalist/features/reports/data/report_api.dart';
import 'package:live_vitalist/features/reports/domain/entities/week_report.dart';
import 'package:live_vitalist/features/reports/domain/report_api_interface.dart';
import 'package:live_vitalist/features/reports/presentation/widgets/week_report_overlay.dart';
import 'package:live_vitalist/features/settings/settings_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final IReportApi api = ref.watch(reportApiProvider);
    final Future<WeekReport?> report = api.loadLatestWeekReport();
    report.then((value) async {
      if (value == null) return;
      await Future.delayed(Duration(seconds: 5));
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => WeekReportOverlay(wr: value),
        );
      }
    });

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
                        builder: (context) => SettingsScreen(),
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
            RatioBarsCard(),
            MealsJournal(),
            NutrientDisplay(),
            SizedBox(height: 12.0),
          ],
        ),
      ),
    );
  }
}
