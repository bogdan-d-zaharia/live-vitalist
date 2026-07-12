import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/settings/settings_screen.dart';

import 'package:live_vitalist/app/super_bar.dart';
import 'package:live_vitalist/nutrient_display.dart';
import 'package:live_vitalist/ratio_bars.dart';
import 'package:live_vitalist/week_calendar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
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
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ListView(
              children: [
                WeekCalendar(),
                ConsumerRatioBars(),
                // MealsJournal(),
                NutrientDisplay(),
                SizedBox(height: 12.0),
              ],
            ),
          ),
          // TODO: Make this a super-search screen
          // A new widget (Scaffold) that has a list of aliments,
          // and the super bar underneath,
          // the body hidden when the super bar is not focused
          // the body shown when the super bar is selected
          Positioned(
            bottom: 20.0,
            left: 12.0,
            right: 12.0,
            child: SuperBar(
              onEnter: null,
              onExit: null,
              onChanged: null,
              onAdd: null,
            ),
          ),
        ],
      ),
    );
  }
}
