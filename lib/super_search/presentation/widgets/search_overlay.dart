import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:live_vitalist/aliment/aliment_bank.dart';
import 'package:live_vitalist/custom_card.dart';
import 'package:live_vitalist/day/day.dart';
import 'package:live_vitalist/day/day_provider.dart';
import 'package:live_vitalist/icon_button.dart';
import 'package:live_vitalist/palette.dart';
import 'package:live_vitalist/super_search/domain/pending_aliment.dart';
import 'package:live_vitalist/super_search/presentation/controllers/aliment_search_controller.dart';
import 'package:live_vitalist/super_search/presentation/widgets/meal_picker_dialog.dart';
import 'package:live_vitalist/super_search/presentation/widgets/selected_aliment_tile.dart';
import 'package:live_vitalist/super_search/super_search_constants.dart';

class SearchOverlay extends ConsumerWidget {
  const SearchOverlay({super.key});

  Future<void> _commitSelection(BuildContext context, WidgetRef ref) async {
    final mealName = await showMealPicker(context);
    if (mealName == null) return;

    final date = ref.read(selectedDatesProvider).first;
    final day = ref.read(cachedSelectedDaysProvider).firstOrNull ?? Day();
    final meal = day.meals.firstWhere((m) => m.name == mealName);

    final selection = ref.read(alimentSearchProvider).selection;
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
    final notifier = ref.read(alimentSearchProvider.notifier);

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
        child: MiniCard(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text('Aliments', style: TextStyle(fontSize: 20.0)),
                    const Spacer(),
                    MyIconButton(
                      onTap: notifier.exit,
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                if (searchState.selection.isNotEmpty) ...[
                  const SizedBox(height: 8.0),
                  ...searchState.selection.map(
                    (item) => SelectedAlimentTile(
                      key: ValueKey(item.alimentID),
                      pending: item,
                    ),
                  ),
                ],
                const Divider(height: 24.0, color: Palette.divGrey),
                Expanded(
                  child: ListView(
                    children: filteredKeys.map((id) {
                      return _ResultTile(
                        name: bank.aliments[id]!.name,
                        isSelected: searchState.isSelected(id),
                        onTap: () => notifier.toggle(
                          PendingAliment(
                            alimentID: id,
                            servingSize: 1.0,
                            unit: bank.aliments[id]!.unit,
                          ),
                        ),
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
    );
  }
}

class _ResultTile extends StatelessWidget {
  const _ResultTile({
    required this.name,
    required this.isSelected,
    required this.onTap,
  });

  final String name;
  final bool isSelected;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return MiniCard(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              Expanded(child: Text(name)),
              if (isSelected)
                const Icon(Icons.check_rounded, color: Palette.selectGreen),
            ],
          ),
        ),
      ),
    );
  }
}
