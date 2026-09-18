import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:live_vitalist/core/network/domain/network_interface.dart';
import 'package:live_vitalist/features/notifications/data/notifications_api.dart';

class _User extends Fake implements User {
  @override
  String get uid => 'uid';
}

class _Auth extends Fake implements FirebaseAuth {
  @override
  User get currentUser => _User();
}

class _Messaging extends Fake implements FirebaseMessaging {
  String? apnsToken;
  bool fail = false;
  bool requestedFcm = false;

  @override
  Future<String?> getAPNSToken() async => apnsToken;

  @override
  Future<String?> getToken({String? vapidKey, String? serviceWorkerScriptPath}) async {
    requestedFcm = true;
    if (fail) {
      throw FirebaseException(
          plugin: 'firebase_messaging', code: 'unavailable');
    }
    return 'fcm';
  }
}

class _Network extends Fake implements INetwork {
  bool fail = false;
  Map? saved;

  @override
  Future<void> post(String path, dynamic data) async {
    if (fail) throw StateError('Offline');
    expect(path, 'save-token');
    saved = data as Map;
  }
}

void main() {
  late _Messaging messaging;
  late _Network network;
  late NotificationsApi api;
  setUp(() {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    messaging = _Messaging();
    network = _Network();
    api = NotificationsApi(network, auth: _Auth(), messaging: messaging);
  });
  tearDown(() => debugDefaultTargetPlatformOverride = null);

  test('missing APNs skips FCM without failing login', () async {
    await api.registerDevice();
    expect(messaging.requestedFcm, isFalse);
    expect(network.saved, isNull);
  });

  test('available APNs registers the FCM token', () async {
    messaging.apnsToken = 'apns';
    await api.registerDevice();
    expect(network.saved, {'fcmToken': 'fcm', 'userId': 'uid'});
  });

  test('FCM failure does not fail login', () async {
    messaging.apnsToken = 'apns';
    messaging.fail = true;
    await expectLater(api.registerDevice(), completes);
  });

  test('token upload failure does not fail login', () async {
    messaging.apnsToken = 'apns';
    network.fail = true;
    await expectLater(api.registerDevice(), completes);
  });

  test('Android registers without requiring APNs', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    await api.registerDevice();
    expect(messaging.requestedFcm, isTrue);
    expect(network.saved, isNotNull);
  });
}
