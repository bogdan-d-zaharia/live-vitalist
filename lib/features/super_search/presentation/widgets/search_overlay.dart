import 'dart:ui';

import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/core/presentation/widgets/mini_card.dart';
import 'package:live_vitalist/features/aliment/data/aliment_bank.dart';
import 'package:live_vitalist/features/day/data/day_provider.dart';
import 'package:live_vitalist/features/super_search/presentation/controllers/super_search_controller.dart';
import 'package:live_vitalist/features/super_search/presentation/utils/super_search_navigation.dart';
import 'package:live_vitalist/features/super_search/presentation/widgets/aliment_result_tile.dart';
import 'package:live_vitalist/features/super_search/presentation/widgets/empty_search.dart';
import 'package:live_vitalist/features/super_search/presentation/widgets/meal_picker_dialog.dart';
import 'package:live_vitalist/features/super_search/presentation/widgets/search_header.dart';
import 'package:live_vitalist/features/super_search/super_search_constants.dart';

class SearchOverlay extends ConsumerWidget {
  const SearchOverlay({super.key});

  Future<void> _commitSelection(BuildContext context, WidgetRef ref) async {
    FocusManager.instance.primaryFocus?.unfocus();

    final searchState = ref.read(superSearchProvider);
    var date = searchState.date;
    var mealName = searchState.mealName;

    if (date == null || mealName == null) {
      mealName = await showMealPicker(context);
      if (mealName == null) return;
      date = ref.read(selectedDatesProvider).first;
    }

    ref
        .read(superSearchProvider.notifier)
        .commitSelection(date: date, mealName: mealName);

    if (context.mounted) SuperSearchNavigation.close(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(superSearchProvider);
    final bank = ref.watch(alimentBankProvider);

    final filteredKeys = bank.order.where((id) {
      final name = bank.aliments[id]!.name;
      return removeDiacritics(name.toLowerCase())
          .contains(removeDiacritics(searchState.query.toLowerCase()));
    }).toList();

    final selectedCount = searchState.selection.length;
    final selectionLabel =
        selectedCount == 1 ? 'Add aliment' : 'Add $selectedCount aliments';

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
            SuperSearchNavigation.close(context);
          },
          child: Padding(
            padding: EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: SuperSearchConstants.overlayBottomInset,
            ),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {},
              child: MiniCard(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25.0,
                    vertical: 20.0,
                  ),
                  child: Column(
                    children: [
                      SearchHeader(
                        query: searchState.query,
                        resultCount: filteredKeys.length,
                      ),
                      Divider(
                        height: 24.0,
                        color: Theme.of(context).dividerColor,
                      ),
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: SuperSearchConstants.overlayFadeDuration,
                          child: filteredKeys.isEmpty
                              ? EmptySearch()
                              : ListView.builder(
                                  key: const ValueKey('search-results'),
                                  padding: EdgeInsets.zero,
                                  itemCount: filteredKeys.length,
                                  itemBuilder: (context, index) {
                                    final id = filteredKeys[index];
                                    return AlimentResultTile(
                                      key: ValueKey(id),
                                      alimentID: id,
                                    );
                                  },
                                ),
                        ),
                      ),
                      AnimatedSize(
                        duration: SuperSearchConstants.overlayFadeDuration,
                        curve: Curves.easeOut,
                        child: searchState.selection.isEmpty
                            ? SizedBox.shrink()
                            : Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 48.0,
                                  child: ElevatedButton.icon(
                                    onPressed: () =>
                                        _commitSelection(context, ref),
                                    icon: const Icon(Icons.add_rounded),
                                    label: Text(selectionLabel),
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
