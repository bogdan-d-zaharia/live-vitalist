import 'package:flutter/material.dart';
import 'package:live_vitalist/features/calendar/calendar.dart';
import 'package:live_vitalist/meals_journal/meals_journal.dart';
import 'package:live_vitalist/nutrient_display.dart';
import 'package:live_vitalist/ratio_bars/ratio_bars_card.dart';
import 'package:live_vitalist/settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
