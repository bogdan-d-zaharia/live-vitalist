import 'package:live_vitalist/features/reports/domain/entities/week_report.dart';

class WeekReportModel extends WeekReport {
  const WeekReportModel({
    required super.number,
    required super.averageIntake,
    required super.completedDays,
    required super.tips,
  });

  factory WeekReportModel.fromJson(Map<String, dynamic> json) {
    return WeekReportModel(
      number: json['number'] as int,
      averageIntake: (json['averageIntake'] as Map)
          .cast<String, num>()
          .map((key, value) => MapEntry(key, value.toDouble())),
      completedDays: (json['completedDays'] as List).cast<bool>(),
      tips: ((json['tips'] ?? []) as List).cast<String>(),
    );
  }

  factory WeekReportModel.fromEntity(WeekReport entity) {
    return WeekReportModel(
      number: entity.number,
      averageIntake: entity.averageIntake,
      completedDays: entity.completedDays,
      tips: entity.tips,
    );
  }
}
