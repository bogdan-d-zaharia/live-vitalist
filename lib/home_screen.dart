import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/features/calendar/calendar.dart';
import 'package:live_vitalist/meals_journal.dart';
import 'package:live_vitalist/nutrient_circle/nutrient_circle.dart';
import 'package:live_vitalist/nutrient_display.dart';
import 'package:live_vitalist/ratio_bars.dart';
import 'package:live_vitalist/settings/settings_screen.dart';
import 'package:live_vitalist/super_search/presentation/add_aliment_actions.dart';
import 'package:live_vitalist/super_search/presentation/controllers/aliment_search_controller.dart';
import 'package:live_vitalist/super_search/presentation/widgets/search_overlay.dart';
import 'package:live_vitalist/super_search/presentation/widgets/super_bar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
                NutrientCircle(),
                NutrientDisplay(),
                ConsumerRatioBars(),
                ...[MealsJournal(), SizedBox(height: 50.0)],
                SizedBox(height: 12.0),
              ],
            ),
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
