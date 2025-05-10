import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;

import '../file_handler.dart';
import 'day.dart';

/// Normalize to date-only.
DateTime _normalize(DateTime date) => DateTime(date.year, date.month, date.day);

String _fileNameFor(DateTime date) => intl.DateFormat('d_M_y').format(date);

final selectedDatesProvider =
    StateProvider<List<DateTime>>((ref) => [_normalize(DateTime.now())]);

/// Reactive `Map<DateTime, Day>`, loaded on demand, auto-saved on edit.
class DayCacheNotifier extends StateNotifier<Map<DateTime, Day>> {
  DayCacheNotifier() : super({});

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
final selectedDaysProvider = FutureProvider<List<Day>>((ref) async {
  final selectedDates = ref.watch(selectedDatesProvider);
  final notifier = ref.read(dayCacheProvider.notifier);

  for (var date in selectedDates) {
    await notifier.load(date);
  }

  final dayCache = ref.watch(dayCacheProvider);

  return selectedDates
      .map((d) => dayCache[_normalize(d)])
      .whereType<Day>()
      .toList();
});
