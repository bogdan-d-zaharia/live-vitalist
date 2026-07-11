import 'package:intl/intl.dart' as intl;
import 'package:live_vitalist/day/day.dart';
import 'package:live_vitalist/day/day_extensions.dart';
import 'package:live_vitalist/day/meal.dart';
import 'package:live_vitalist/storage/data/storage_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'day_provider.g.dart';

extension DateTimeNormalizer on DateTime {
  /// Normalize to date-only.
  DateTime get normalized => DateTime(year, month, day);
  String get fileName => intl.DateFormat('d_M_y').format(this);
}

@riverpod
class SelectedDates extends _$SelectedDates {
  @override
  List<DateTime> build() => [DateTime.now().normalized];

  void update(List<DateTime> dates) => state = dates;
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

/// Returns the list of Day objects for currently selected dates
@riverpod
Future<List<Day>> selectedDays(Ref ref) async {
  final selectedDates = ref.watch(selectedDatesProvider);
  final notifier = ref.read(dayCacheProvider.notifier);
  return Future.wait(selectedDates.map((date) => notifier.load(date)).toList());
}

// TODO: Can this be simplified?
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
