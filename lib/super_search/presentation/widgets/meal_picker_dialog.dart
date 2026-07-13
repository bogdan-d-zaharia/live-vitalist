import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/day/data/day_provider.dart';
import 'package:live_vitalist/day/domain/day.dart';

/// Asks in which meal the aliments go; pops with the meal name.
Future<String?> showMealPicker(BuildContext context) {
  return showDialog<String>(
    context: context,
    builder: (_) => const MealPickerDialog(),
  );
}

class MealPickerDialog extends ConsumerWidget {
  const MealPickerDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = ref.watch(syncSelectedDaysProvider)?.firstOrNull ?? Day();

    final children = day.meals
        .map(
          (meal) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 160.0,
              height: 40.0,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, meal.name),
                child: Center(child: Text(meal.name)),
              ),
            ),
          ),
        )
        .toList();

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Add to meal', style: TextStyle(fontSize: 20.0)),
            const SizedBox(height: 8.0),
            SingleChildScrollView(
              child: Column(children: children),
            ),
          ],
        ),
      ),
    );
  }
}
