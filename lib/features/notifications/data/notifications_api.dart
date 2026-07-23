import 'package:live_vitalist/core/network/data/network_provider.dart';
import 'package:live_vitalist/core/network/domain/network_interface.dart';
import 'package:live_vitalist/features/notifications/domain/notifications_api_interface.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifications_api.g.dart';

class NotificationsApi implements INotificationsApi {
  final INetwork _networkHandler;
  NotificationsApi(this._networkHandler);

  @override
  Future<void> saveToken(String userId, String fcmToken) async {
    _networkHandler.post('save-token', {
      'fcmToken': fcmToken,
      'userId': userId,
    });
  }
}

@riverpod
INotificationsApi notificationsApi(Ref ref) {
  final INetwork network = ref.watch(networkProvider);
  return NotificationsApi(network);
}
