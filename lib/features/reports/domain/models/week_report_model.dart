import 'package:live_vitalist/features/reports/domain/entities/week_report.dart';

class WeekDataModel extends WeekData {
  const WeekDataModel({
    required super.number,
    required super.averageIntake,
    required super.completedDays,
    required super.tips,
  });

  factory WeekDataModel.fromJson(Map<String, dynamic> json) {
    return WeekDataModel(
      number: json['number'] as int,
      averageIntake: (json['averageIntake'] as Map)
          .cast<String, num>()
          .map((key, value) => MapEntry(key, value.toDouble())),
      completedDays: (json['completedDays'] as List).cast<bool>(),
      tips: ((json['tips'] ?? []) as List).cast<String>(),
    );
  }

  factory WeekDataModel.fromEntity(WeekData entity) {
    return WeekDataModel(
      number: entity.number,
      averageIntake: entity.averageIntake,
      completedDays: entity.completedDays,
      tips: entity.tips,
    );
  }
}

class WeekReportModel extends WeekReport {
  const WeekReportModel({
    required super.currentWeek,
    required super.previousWeek,
  });

  factory WeekReportModel.fromJson(Map<String, dynamic> json) {
    return WeekReportModel(
      currentWeek: WeekDataModel.fromJson(json['currentWeek']),
      previousWeek: WeekDataModel.fromJson(json['previousWeek']),
    );
  }

  factory WeekReportModel.fromEntity(WeekReport entity) {
    return WeekReportModel(
      currentWeek: entity.currentWeek,
      previousWeek: entity.previousWeek,
    );
  }
}
