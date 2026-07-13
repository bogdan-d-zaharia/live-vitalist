import 'package:intl/intl.dart' as intl;
import 'package:live_vitalist/day/domain/day.dart';
import 'package:live_vitalist/day/domain/day_extensions.dart';
import 'package:live_vitalist/day/domain/meal.dart';
import 'package:live_vitalist/core/storage/data/storage_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'day_provider.g.dart';

// TODO: Save records by the month

extension DateTimeNormalizer on DateTime {
  /// Normalize to date-only.
  DateTime get normalized => DateTime(year, month, day);
  String get fileName => intl.DateFormat('d_M_y').format(this);
}

@riverpod
class SelectedDates extends _$SelectedDates {
  @override
  List<DateTime> build() => [DateTime.now().normalized];

  void setSingleDate(DateTime date) => state = [date];
  void toggleDate(DateTime date) {
    if (!state.contains(date)) {
      state = [...state, date];
    } else if (state.length > 1) {
      state = [...state]..remove(date);
    }
  }
}

/// `Map<DateTime, Day>`
@Riverpod(keepAlive: true)
class DayCache extends _$DayCache {
  @override
  Map<DateTime, Day> build() => {};

  Future<Day> load(DateTime date) async {
    final normalized = date.normalized;
    if (state.containsKey(normalized)) {
      return state[normalized]!;
    }

    final path = 'records/${normalized.fileName}';
    final json = await ref.read(storageProvider.notifier).loadJson(path);
    final day = Day.fromJson(json ?? {});
    state = {...state, normalized: day};
    return day;
  }

  Future<void> save(DateTime date, Day day) async {
    final normalized = date.normalized;
    state = {...state, normalized: day};
    final path = 'records/${normalized.fileName}';
    await ref.read(storageProvider.notifier).saveJson(path, day.toJson());
  }

  void removeMeal(DateTime date, Day day, Meal meal) {
    final meals = [...day.meals]..removeWhere((e) => e.name == meal.name);
    save(date, Day(meals: meals));
  }

  void addMeal(DateTime date, Day day, Meal meal) {
    final meals = [...day.meals, meal];
    save(date, Day(meals: meals));
  }
}

@riverpod
List<Day>? syncSelectedDays(Ref ref) {
  final selectedDates = ref.watch(selectedDatesProvider);
  final dayCache = ref.watch(dayCacheProvider);
  final notifier = ref.read(dayCacheProvider.notifier);

  bool isAll = true;
  for (var date in selectedDates) {
    if (dayCache[date] == null) {
      notifier.load(date);
      isAll = false;
    }
  }
  return isAll ? selectedDates.map((date) => dayCache[date]!).toList() : null;
}

@riverpod
Day syncAverageDay(Ref ref) {
  final days = ref.watch(syncSelectedDaysProvider);
  return days?.average() ?? Day();
}
