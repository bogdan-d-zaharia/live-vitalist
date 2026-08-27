import 'package:live_vitalist/features/aliment/data/aliment_bank.dart';
import 'package:live_vitalist/features/day/data/day_provider.dart';
import 'package:live_vitalist/features/super_search/domain/pending_aliment.dart';
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

  void toggle(PendingAliment aliment) {
    if (state.isSelected(aliment.alimentID)) {
      remove(aliment.alimentID);
    } else {
      state = state.copyWith(selection: [...state.selection, aliment]);
    }
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
      dayNotifier.addAliment(date, mealName, item.toInstanced());
    }

    final bankNotifier = ref.read(alimentBankProvider.notifier);
    for (final item in selection.reversed) {
      bankNotifier.setFirst(item.alimentID);
    }
  }
}
