import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/core/presentation/widgets/gradient_scaffold.dart';
import 'package:live_vitalist/features/calorie_distribution/calorie_distribution_card.dart';
import 'package:live_vitalist/features/announcements/data/announcements.dart';
import 'package:live_vitalist/features/announcements/data/announcements_api.dart';
import 'package:live_vitalist/features/announcements/domain/announcements_api_interface.dart';
import 'package:live_vitalist/features/calendar/calendar.dart';
import 'package:live_vitalist/features/meals_journal/meals_journal.dart';
import 'package:live_vitalist/features/nutrient_display/nutrient_display.dart';
import 'package:live_vitalist/features/ratio_bars/ratio_bars_card.dart';
import 'package:live_vitalist/features/settings/settings_screen.dart';
import 'package:live_vitalist/features/nutrient_circle/nutrient_circle.dart';
import 'package:live_vitalist/features/super_search/presentation/add_aliment_actions.dart';
import 'package:live_vitalist/features/super_search/presentation/controllers/aliment_search_controller.dart';
import 'package:live_vitalist/features/super_search/presentation/widgets/search_overlay.dart';
import 'package:live_vitalist/features/super_search/presentation/widgets/super_bar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AlimentSearchState>(alimentSearchProvider, (previous, next) {
      if (previous?.isActive == true && !next.isActive) {
        _searchController.clear();
        FocusManager.instance.primaryFocus?.unfocus();
      }
    });

    final searchNotifier = ref.read(alimentSearchProvider.notifier);

    return GradientScaffold(
      extendBodyBehindAppBar: true,
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
          ListView(
            padding: EdgeInsets.only(
              top: MediaQuery.viewPaddingOf(context).top + kToolbarHeight,
              bottom: 100.0,
              left: 8.0,
              right: 8.0,
            ),
            children: [
              WeekCalendar(),
              NutrientCircle(),
              NutrientDisplay(),
              CalorieDistributionCard(),
              RatioBarsCard(),
              MealsJournal(),
            ],
          ),
          Positioned.fill(
            child: SearchOverlay(),
          ),
          Positioned(
            bottom: 20.0,
            left: 12.0,
            right: 12.0,
            child: TextFieldTapRegion(
              child: SuperBar(
                controller: _searchController,
                onEnter: searchNotifier.enter,
                onExit: searchNotifier.exit,
                onChanged: searchNotifier.setQuery,
                onAdd: (isTemp, isGen) {
                  if (isGen) {
                    AddAlimentActions.addGenerated(
                      context,
                      ref,
                      _searchController.text,
                      isTemp: isTemp,
                    );
                  } else if (isTemp) {
                    AddAlimentActions.addTemporary(context, ref);
                  } else {
                    AddAlimentActions.addInstanced(context, ref);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
