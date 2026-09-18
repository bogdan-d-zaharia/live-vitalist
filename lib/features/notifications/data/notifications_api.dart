import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:live_vitalist/core/network/data/network_provider.dart';
import 'package:live_vitalist/core/network/domain/network_interface.dart';
import 'package:live_vitalist/features/notifications/domain/notifications_api_interface.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifications_api.g.dart';

class NotificationsApi implements INotificationsApi {
  final INetwork _networkHandler;
  final FirebaseAuth? _auth;
  final FirebaseMessaging? _messaging;
  NotificationsApi(this._networkHandler,
      {FirebaseAuth? auth, FirebaseMessaging? messaging})
      : _auth = auth,
        _messaging = messaging;

  /// Push registration is optional and must never fail an authenticated login.
  @override
  Future<void> registerDevice() async {
    try {
      final userId = (_auth ?? FirebaseAuth.instance).currentUser?.uid;
      if (userId == null) return;
      final messaging = _messaging ?? FirebaseMessaging.instance;
      final usesApns = !kIsWeb &&
          (defaultTargetPlatform == TargetPlatform.iOS ||
              defaultTargetPlatform == TargetPlatform.macOS);
      if (usesApns && await messaging.getAPNSToken() == null) return;
      final token = await messaging.getToken();
      if (token == null) return;
      await saveToken(userId, token);
    } catch (error, stackTrace) {
      debugPrint('Push registration skipped: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  @override
  Future<void> saveToken(String userId, String fcmToken) async {
    await _networkHandler.post('save-token', {
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
