import 'day.dart';

abstract final class DayHandler {
  static final Map<DateTime, Day> cache = {};

  /// This function is guarded,
  /// meaning hours, minutes, seconds etc. don't matter.
  static Future<Day> getDay(DateTime date) async {
    date = DateTime(date.year, date.month, date.day);

    if (!cache.containsKey(date)) {
      final Day day = Day();
      await day.load(date);

      cache[date] = day;
    }

    return cache[date]!;
  }
}
