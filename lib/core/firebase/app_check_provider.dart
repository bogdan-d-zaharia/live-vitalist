import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:live_vitalist/core/firebase/firebase_initialization_provider.dart';

part 'app_check_provider.g.dart';

@Riverpod(keepAlive: true)
Future<void> appCheck(Ref ref) async {
  await ref.watch(firebaseInitializationProvider.future);

  await FirebaseAppCheck.instance.activate(
    providerAndroid:
        kDebugMode ? AndroidDebugProvider() : AndroidPlayIntegrityProvider(),
    providerApple: kDebugMode ? AppleDebugProvider() : AppleAppAttestProvider(),
  );
}
