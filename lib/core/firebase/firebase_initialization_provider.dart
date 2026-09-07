import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:live_vitalist/firebase_options.dart';

part 'firebase_initialization_provider.g.dart';

@Riverpod(keepAlive: true)
Future<void> firebaseInitialization(Ref ref) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(
      error,
      stackTrace,
      fatal: true,
    );
    return true;
  };
}
