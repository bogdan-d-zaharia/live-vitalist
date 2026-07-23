import 'package:live_vitalist/core/api/domain/api_type_exception.dart';
import 'package:live_vitalist/core/network/data/network_provider.dart';
import 'package:live_vitalist/core/network/domain/network_interface.dart';
import 'package:live_vitalist/features/reports/domain/models/week_report_model.dart';
import 'package:live_vitalist/features/reports/domain/report_api_interface.dart';
import 'package:live_vitalist/features/reports/domain/entities/week_report.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'report_api.g.dart';

class ReportApi implements IReportApi {
  final INetwork _networkHandler;
  ReportApi(this._networkHandler);

  @override
  Future<WeekReport> loadLatestWeekReport() async {
    final json = await _networkHandler.get('load-latest-week-report');
    try {
      return WeekReportModel.fromJson(json);
    } catch (e) {
      throw ApiTypeException();
    }
  }
}

@riverpod
IReportApi reportApi(Ref ref) {
  final INetwork network = ref.watch(networkProvider);
  return ReportApi(network);
}
