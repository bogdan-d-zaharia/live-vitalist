import 'package:live_vitalist/features/reports/domain/entities/week_report.dart';

abstract interface class IReportApi {
  Future<WeekReport> loadLatestWeekReport();
}
