import 'package:live_vitalist/features/reports/domain/entities/week_report.dart';

class WeekReportModel extends WeekReport {
  const WeekReportModel({
    required super.number,
    super.averageCalories,
  });

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'averageCalories': averageCalories,
    };
  }

  factory WeekReportModel.fromJson(Map<String, dynamic> json) {
    return WeekReportModel(
      number: json['number'],
      averageCalories: json['averageCalories'],
    );
  }

  factory WeekReportModel.fromEntity(WeekReport entity) {
    return WeekReportModel(
      number: entity.number,
      averageCalories: entity.averageCalories,
    );
  }
}
