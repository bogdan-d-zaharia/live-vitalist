import 'package:intl/intl.dart' as intl;
import 'package:live_vitalist/day/day.dart';
import 'package:live_vitalist/storage/data/storage_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'day_provider.g.dart';

extension DateTimeNormalizer on DateTime {
  /// Normalize to date-only.
  DateTime get normalized => DateTime(year, month, day);
}

String _fileNameFor(DateTime date) => intl.DateFormat('d_M_y').format(date);

@riverpod
class SelectedDates extends _$SelectedDates {
  @override
  List<DateTime> build() => [DateTime.now().normalized];

  void update(List<DateTime> dates) => state = dates;
}

/// Reactive `Map<DateTime, Day>`, loaded on demand, auto-saved on edit.
@riverpod
class DayCache extends _$DayCache {
  @override
  Map<DateTime, Day> build() => {};

  /// Access a Day for the given date. Loads from disk if needed.
  Future<bool> load(DateTime date) async {
    final normalized = date.normalized;
    if (state.containsKey(normalized)) return true;

    final fileName = _fileNameFor(normalized);
    final json = await ref.read(storageProvider.notifier).loadJson(fileName);
    final day = Day.fromJson(json ?? {});
    state = {...state, normalized: day};

    return json != null;
  }

  Future<void> setDay(DateTime date, Day day) async {
    final normalized = date.normalized;
    state = {...state, normalized: day};
    await day.save(normalized);
  }

  void clear() {
    state = {};
  }
}

/// Returns the list of Day objects for currently selected dates
@riverpod
Future<List<Day>> selectedDays(Ref ref) async {
  final selectedDates = ref.watch(selectedDatesProvider);
  final notifier = ref.read(dayCacheProvider.notifier);

  for (var date in selectedDates) {
    await notifier.load(date);
  }

  final dayCache = ref.watch(dayCacheProvider);

  return selectedDates
      .map((d) => dayCache[d.normalized])
      .whereType<Day>()
      .toList();
}

@riverpod
class CachedSelectedDays extends _$CachedSelectedDays {
  @override
  List<Day> build() {
    ref.listen<AsyncValue<List<Day>>>(
      selectedDaysProvider,
      (previous, next) {
        next.whenData((days) {
          if (days.isNotEmpty) {
            state = days;
          }
        });
      },
    );
    return [];
  }
}

@riverpod
Day averageDayCached(Ref ref) {
  final days = ref.watch(cachedSelectedDaysProvider);
  return days.average();
}
