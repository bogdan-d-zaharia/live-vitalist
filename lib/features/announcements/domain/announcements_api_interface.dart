import 'package:live_vitalist/features/announcements/data/announcements.dart';

abstract interface class IAnnouncementsApi {
  Stream<IAnnouncement> fetchAnnouncements();
}
