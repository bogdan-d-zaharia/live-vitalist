import 'package:flutter/foundation.dart';

@immutable
class WeekReport {
  final int number;
  final Map<String, double> averageIntake;
  final List<bool> completedDays;
  final List<String> tips;

  const WeekReport({
    required this.number,
    required this.averageIntake,
    required this.tips,
    required this.completedDays,
  });
}
