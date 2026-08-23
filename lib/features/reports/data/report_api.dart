import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:live_vitalist/core/api/domain/api_type_exception.dart';
import 'package:live_vitalist/core/network/data/network_provider.dart';
import 'package:live_vitalist/core/network/domain/network_interface.dart';
import 'package:live_vitalist/features/reports/domain/models/week_report_model.dart';
import 'package:live_vitalist/features/reports/domain/report_api_interface.dart';
import 'package:live_vitalist/features/reports/domain/entities/week_report.dart';
import 'package:live_vitalist/features/settings/data/settings_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'report_api.g.dart';

class ReportApi implements IReportApi {
  final INetwork _networkHandler;
  ReportApi(this._networkHandler);

  @override
  Future<WeekReport?> loadLatestWeekReport() async {
    final wrdr = SettingsData.lastWeekReportReadDate;
    if (wrdr != null) {
      final now = DateTime.now();
      final lastSunday = wrdr.add(Duration(days: 7 - wrdr.weekday));
      final latestSunday = now.add(Duration(days: 7 - now.weekday));
      final strA = DateFormat('yyyy-MM-dd').format(lastSunday);
      final strB = DateFormat('yyyy-MM-dd').format(latestSunday);
      if (strA == strB) return null; // Already shown this week
    }

    // TODO: Solve technical debt
    bool hasError = false;
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return null;
    final json = await _networkHandler.get('$userId/load-latest-week-report');
    try {
      return WeekReportModel.fromJson(json);
    } catch (e) {
      hasError = true;
      throw ApiTypeException();
    } finally {
      if (!hasError) SettingsData.lastWeekReportReadDate = DateTime.now();
    }
  }
}

@riverpod
IReportApi reportApi(Ref ref) {
  final INetwork network = ref.watch(networkProvider);
  return ReportApi(network);
}
