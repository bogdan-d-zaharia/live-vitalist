import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;

import '../file_handler.dart';
import 'day.dart';

String _fileNameFor(DateTime date) => intl.DateFormat('d_M_y').format(date);

final selectedDatesProvider = StateProvider<List<DateTime>>((ref) => []);

/// Reactive `Map<DateTime, Day>`, loaded on demand, auto-saved on edit.
class DayCacheNotifier extends StateNotifier<Map<DateTime, Day>> {
  DayCacheNotifier() : super({});

  /// Normalize to date-only.
  DateTime _normalize(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  /// Access a Day for the given date. Loads from disk if needed.
  Future<bool> load(DateTime date) async {
    final normalized = _normalize(date);
    if (state.containsKey(normalized)) return true;

    final fileName = _fileNameFor(normalized);
    final json = await StorageHandler.loadJson(fileName);
    final day = Day()..fromJson(json ?? {});
    state = {...state, normalized: day};

    return json != null;
  }

  Future<void> setDay(DateTime date, Day day) async {
    final normalized = _normalize(date);
    state = {...state, normalized: day};
    await day.save(normalized);
  }
}

final dayCacheProvider =
    StateNotifierProvider<DayCacheNotifier, Map<DateTime, Day>>(
  (ref) => DayCacheNotifier(),
);

/// Returns the list of Day objects for currently selected dates
final selectedDaysProvider = Provider<List<Day>>((ref) {
  final selectedDates = ref.watch(selectedDatesProvider);
  final dayCache = ref.watch(dayCacheProvider);

  return selectedDates
      .map((d) => dayCache[DateTime(d.year, d.month, d.day)])
      .whereType<Day>()
      .toList();
});
