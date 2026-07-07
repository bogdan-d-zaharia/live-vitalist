import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/app/selector.dart';

import 'package:live_vitalist/custom_card.dart';
import 'package:live_vitalist/day/day.dart';
import 'package:live_vitalist/day/day_provider.dart';

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
                onPressed: () async {
                  final aliments = Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Selector(),
                    ),
                  );
                },
                child: Center(child: Text(meal.name)),
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
