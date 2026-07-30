import 'package:live_vitalist/features/announcements/data/announcements.dart';
import 'package:live_vitalist/features/announcements/domain/announcements_api_interface.dart';
import 'package:live_vitalist/features/legal/data/legal_handler.dart';
import 'package:live_vitalist/features/legal/domain/legal_types.dart';
import 'package:live_vitalist/features/reports/data/report_api.dart';
import 'package:live_vitalist/features/reports/domain/report_api_interface.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'announcements_api.g.dart';

class AnnouncementsApi implements IAnnouncementsApi {
  final IReportApi _reportApi;
  final ILegalHandler _legalHandler;
  AnnouncementsApi(this._reportApi, this._legalHandler);

  @override
  Stream<IAnnouncement> fetchAnnouncements() async* {
    final requirements = await _legalHandler.fetch();
    if (requirements.isNotEmpty) yield LegalAnnouncement(requirements);
    final weekReport = await _reportApi.loadLatestWeekReport();
    if (weekReport != null) yield WeekReportAnnouncement(weekReport);
  }
}

@riverpod
IAnnouncementsApi announcementsApi(Ref ref) {
  final IReportApi reportApi = ref.watch(reportApiProvider);
  final ILegalHandler legalHandler = ref.watch(legalHandlerProvider);
  return AnnouncementsApi(reportApi, legalHandler);
}
