import 'package:live_vitalist/features/announcements/domain/announcement_interface.dart';

abstract interface class IAnnouncementsApi {
  Future<IAnnouncement> fetchAnnouncements();
}
