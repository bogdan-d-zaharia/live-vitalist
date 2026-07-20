import 'package:intl/intl.dart' as intl;
import 'package:live_vitalist/features/aliment/domain/aliment.dart';
import 'package:live_vitalist/features/day/domain/day.dart';
import 'package:live_vitalist/features/day/domain/day_extensions.dart';
import 'package:live_vitalist/features/day/domain/meal.dart';
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

  Future<void> _save(DateTime date, Day day) async {
    final normalized = date.normalized;
    state = {...state, normalized: day};
    final path = 'records/${normalized.fileName}';
    await ref.read(storageProvider.notifier).saveJson(path, day.toJson());
  }

  Future<void> removeMeal(DateTime date, String mealName) async {
    final day = await load(date);
    final meals = [...day.meals]..removeWhere((e) => e.name == mealName);
    _save(date, Day(meals: meals));
  }

  Future<void> addMeal(DateTime date, Meal meal) async {
    final day = await load(date);
    final meals = [...day.meals, meal];
    _save(date, Day(meals: meals));
  }

  // TODO: Momentan se muteaza obiectul Meal
  // day.meals[...].alimente.muteaza()
  // trebuie rezolvat dupa ce Meal devine @freezed.

  Future<void> addAliment(
      DateTime date, String mealName, Aliment aliment) async {
    final day = await load(date);
    final meal = day.meals.firstWhere((meal) => meal.name == mealName);
    meal.aliments.add(aliment);
    final meals = [...day.meals];
    _save(date, Day(meals: meals));
  }

  Future<void> removeAliment(
      DateTime date, String mealName, Aliment aliment) async {
    final day = await load(date);
    final meal = day.meals.firstWhere((meal) => meal.name == mealName);
    meal.aliments.remove(aliment);
    final meals = [...day.meals];
    _save(date, Day(meals: meals));
  }

  Future<void> updateAliment(
    DateTime date,
    String mealName,
    Aliment oldAliment,
    Aliment newAliment,
  ) async {
    final day = await load(date);
    final meal = day.meals.firstWhere((meal) => meal.name == mealName);
    final idx = meal.aliments.indexOf(oldAliment);
    meal.aliments
      ..removeAt(idx)
      ..insert(idx, newAliment);
    final meals = [...day.meals];
    _save(date, Day(meals: meals));
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
