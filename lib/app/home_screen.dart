import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/features/announcements/data/announcements.dart';
import 'package:live_vitalist/features/announcements/data/announcements_api.dart';
import 'package:live_vitalist/features/announcements/domain/announcements_api_interface.dart';
import 'package:live_vitalist/features/calendar/calendar.dart';
import 'package:live_vitalist/features/meals_journal/meals_journal.dart';
import 'package:live_vitalist/features/nutrient_display/nutrient_display.dart';
import 'package:live_vitalist/features/ratio_bars/ratio_bars_card.dart';
import 'package:live_vitalist/features/settings/data/settings_data.dart';
import 'package:live_vitalist/features/nutrient_circle/nutrient_circle.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final Future<void> Function() onOpenSettings;
  final Future<void> Function(String mealName, DateTime date) onOpenMeal;

  const HomeScreen({
    super.key,
    required this.onOpenSettings,
    required this.onOpenMeal,
  });

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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
            child: Container(color: Colors.white.withValues(alpha: 0.0)),
          ),
        ),
        title: Text('Live Vitalist'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 24.0),
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
                  onTap: () async {
                    await widget.onOpenSettings();
                    if (mounted) setState(() {});
                  },
                  child: Icon(Icons.settings_rounded, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.only(
          bottom: 100.0,
          left: 8.0,
          right: 8.0,
        ),
        children: [
          WeekCalendar(),
          NutrientCircle(),
          NutrientDisplay(),
          if (SettingsData.isShowCalorieDistribution ||
              SettingsData.isShowOmegaBalance)
            RatioBarsCard(),
          MealsJournal(onOpenMeal: widget.onOpenMeal),
        ],
      ),
    );
  }
}
