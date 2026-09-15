import 'package:live_vitalist/features/aliment_bank/data/aliment_bank.dart';
import 'package:live_vitalist/features/aliment/domain/aliment.dart';
import 'package:live_vitalist/features/day/data/day_provider.dart';
import 'package:live_vitalist/features/super_search/domain/super_search_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'super_search_controller.g.dart';

@Riverpod(keepAlive: true)
class SuperSearch extends _$SuperSearch {
  @override
  SuperSearchState build() => const SuperSearchState();

  void enter({DateTime? date, String? mealName}) =>
      state = state.copyWith(date: date, mealName: mealName);

  void exit() => state = const SuperSearchState();

  void setQuery(String query) => state = state.copyWith(query: query);

  Future<void> toggle(InstancedAliment aliment) async {
    if (state.isSelected(aliment.alimentID)) {
      remove(aliment.alimentID);
      return;
    }

    final quantities = await ref.read(lastUsedQuantitiesProvider.future);
    if (state.isSelected(aliment.alimentID)) return;

    final lastUsedQuantity = quantities[aliment.alimentID];
    final selectedAliment = lastUsedQuantity == null
        ? aliment
        : aliment.copyWith(
            servingSize: lastUsedQuantity.amount,
            unit: lastUsedQuantity.unit,
          );
    state = state.copyWith(selection: [...state.selection, selectedAliment]);
  }

  void updateAliment(InstancedAliment aliment) {
    state = state.copyWith(
      selection: state.selection
          .map((item) => item.alimentID == aliment.alimentID ? aliment : item)
          .toList(),
    );
  }

  void remove(String alimentID) {
    state = state.copyWith(
      selection:
          state.selection.where((item) => item.alimentID != alimentID).toList(),
    );
  }

  void commitSelection({required DateTime date, required String mealName}) {
    final selection = state.selection;
    final dayNotifier = ref.read(dayCacheProvider.notifier);

    for (final item in selection) {
      dayNotifier.addAliment(date, mealName, item);
    }

    final bankNotifier = ref.read(alimentBankControllerProvider.notifier);
    for (final item in selection.reversed) {
      bankNotifier.selectAliment(item);
    }
  }
}
