import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/aliment/aliment.dart';
import 'package:live_vitalist/aliment_editor/instance_editor.dart';
import 'package:live_vitalist/custom_card.dart';
import 'package:live_vitalist/day/day.dart';
import 'package:live_vitalist/day/day_provider.dart';
import 'package:live_vitalist/meals_journal.dart';

// import 'meals_journal.dart';
import 'nutrient_display.dart';
import 'ratio_bars.dart';
import 'settings.dart';
import 'week_calendar.dart';

class MealAddSelector extends ConsumerWidget {
  const MealAddSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = ref.watch(cachedSelectedDaysProvider).firstOrNull ?? Day();
    final date = ref.watch(selectedDatesProvider).first;
    final children = day.meals
        .map(
          (meal) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 120.0,
              height: 40.0,
              child: ElevatedButton(
                child: Center(child: Text(meal.name)),
                onPressed: () async {
                  //TODO: Copied to `MealEditor`

                  Navigator.pop(context);
                  final newAliment = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InstanceEditor(
                        initialAliment: InstancedAliment.empty,
                      ),
                    ),
                  );

                  if (newAliment != null && newAliment.alimentID != '') {
                    meal.aliments.add(newAliment);
                    ref.read(dayCacheProvider.notifier).setDay(date, day);
                  }
                },
                onLongPress: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MealEditor(
                        mealName: meal.name,
                        date: date,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        )
        .toList();

    return MiniCard(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(children: children),
        ),
      ),
    );
  }
}

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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_rounded),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => Center(
              child: MealAddSelector(),
            ),
          );
        },
      ),
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
            ConsumerRatioBars(),
            // MealsJournal(),
            NutrientDisplay(),
            SizedBox(height: 12.0),
          ],
        ),
      ),
    );
  }
}
