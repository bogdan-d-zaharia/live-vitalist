import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/features/announcements/data/announcements.dart';
import 'package:live_vitalist/features/announcements/data/announcements_api.dart';
import 'package:live_vitalist/features/announcements/domain/announcements_api_interface.dart';
import 'package:live_vitalist/features/calendar/calendar.dart';
import 'package:live_vitalist/features/meals_journal/meals_journal.dart';
import 'package:live_vitalist/features/nutrient_display/nutrient_display.dart';
import 'package:live_vitalist/features/ratio_bars/ratio_bars_card.dart';
import 'package:live_vitalist/features/settings/settings_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Future<void> showPopups() async {
    final IAnnouncementsApi api = ref.watch(announcementsApiProvider);
    await for (final IAnnouncement announcement in api.fetchAnnouncements()) {
      await announcement.pushAnnouncementPopup(context);
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showPopups();
    });
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
