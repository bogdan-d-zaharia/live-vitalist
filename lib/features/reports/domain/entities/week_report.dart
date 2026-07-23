import 'package:flutter/foundation.dart';

@immutable
class WeekReport {
  final int number;
  final double? averageCalories;

  const WeekReport({
    required this.number,
    this.averageCalories,
  });
}
