import 'package:live_vitalist/core/network/data/network_provider.dart';
import 'package:live_vitalist/core/network/domain/network_interface.dart';
import 'package:live_vitalist/features/announcements/domain/announcement_interface.dart';
import 'package:live_vitalist/features/announcements/domain/announcements_api_interface.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'announcements_api.g.dart';

class AnnouncementsApi implements IAnnouncementsApi {
  final INetwork _networkHandler;
  AnnouncementsApi(this._networkHandler);

  @override
  Future<IAnnouncement> fetchAnnouncements() {
    _networkHandler.get(path)
  }
}

@riverpod
IAnnouncementsApi announcementsApi(Ref ref) {
  final INetwork network = ref.watch(networkProvider);

  return AnnouncementsApi();
}
