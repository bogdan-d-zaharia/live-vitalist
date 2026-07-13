import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:live_vitalist/aliment/aliment_bank.dart';
import 'package:live_vitalist/custom_card.dart';
import 'package:live_vitalist/day/day.dart';
import 'package:live_vitalist/day/day_provider.dart';
import 'package:live_vitalist/palette.dart';
import 'package:live_vitalist/super_search/presentation/controllers/aliment_search_controller.dart';
import 'package:live_vitalist/super_search/presentation/widgets/aliment_result_tile.dart';
import 'package:live_vitalist/super_search/presentation/widgets/meal_picker_dialog.dart';
import 'package:live_vitalist/super_search/super_search_constants.dart';

class SearchOverlay extends ConsumerWidget {
  const SearchOverlay({super.key});

  Future<void> _commitSelection(BuildContext context, WidgetRef ref) async {
    final selection = ref.read(alimentSearchProvider).selection;
    FocusManager.instance.primaryFocus?.unfocus();

    final mealName = await showMealPicker(context);
    if (mealName == null) return;

    final date = ref.read(selectedDatesProvider).first;
    final day = ref.read(cachedSelectedDaysProvider).firstOrNull ?? Day();
    final meal = day.meals.firstWhere((m) => m.name == mealName);

    meal.aliments.addAll(selection.map((item) => item.toInstanced()));
    ref.read(dayCacheProvider.notifier).save(date, day);

    final bankNotifier = ref.read(alimentBankProvider.notifier);
    for (final item in selection.reversed) {
      bankNotifier.setFirst(item.alimentID);
    }

    ref.read(alimentSearchProvider.notifier).exit();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(alimentSearchProvider);
    final bank = ref.watch(alimentBankProvider);

    final filteredKeys = bank.order.where((id) {
      final name = bank.aliments[id]!.name;
      return removeDiacritics(name.toLowerCase())
          .contains(removeDiacritics(searchState.query.toLowerCase()));
    }).toList();

    return IgnorePointer(
      ignoring: !searchState.isActive,
      child: AnimatedOpacity(
        opacity: searchState.isActive ? 1.0 : 0.0,
        duration: SuperSearchConstants.overlayFadeDuration,
        curve: Curves.easeOut,
        child: TextFieldTapRegion(
          child: MiniCard(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 12.0,
                right: 12.0,
                top: 16.0,
                bottom: SuperSearchConstants.overlayBottomInset,
              ),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Aliments', style: TextStyle(fontSize: 20.0)),
                  ),
                  const Divider(height: 24.0, color: Palette.divGrey),
                  Expanded(
                    child: ListView(
                      children: filteredKeys.map((id) {
                        return AlimentResultTile(
                          key: ValueKey(id),
                          alimentID: id,
                        );
                      }).toList(),
                    ),
                  ),
                  if (searchState.selection.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 40.0,
                        child: ElevatedButton(
                          onPressed: () => _commitSelection(context, ref),
                          child: const Text('Done'),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
