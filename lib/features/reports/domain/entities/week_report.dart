import 'package:flutter/foundation.dart';

@immutable
class WeekData {
  final int number;
  final Map<String, double> averageIntake;
  final List<bool> completedDays;
  final List<String>? tips;

  const WeekData({
    required this.number,
    required this.averageIntake,
    this.tips,
    required this.completedDays,
  });
}

@immutable
class WeekReport {
  final WeekData currentWeek;
  final WeekData previousWeek;

  const WeekReport({
    required this.currentWeek,
    required this.previousWeek,
  });
}
