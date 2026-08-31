DateTime isoWeekStart(int year, int week) {
  final firstThursday = DateTime(year, 1, 4);
  final firstMonday = firstThursday.subtract(
    Duration(days: firstThursday.weekday - DateTime.monday),
  );
  return firstMonday.add(Duration(days: (week - 1) * 7));
}
