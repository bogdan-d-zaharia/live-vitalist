import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:live_vitalist/features/aliment/data/aliment_bank.dart';
import 'package:live_vitalist/features/app_initialization/domain/app_initialization_state.dart';
import 'package:live_vitalist/features/legal/data/legal_handler.dart';
import 'package:live_vitalist/features/notifications/notification_handler.dart';
import 'package:live_vitalist/features/nutrient/data/nutrient_provider.dart';
import 'package:live_vitalist/features/onboarding/domain/onboarding_data.dart';
import 'package:live_vitalist/features/settings/data/settings_data.dart';
import 'package:live_vitalist/firebase_options.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_initialization_provider.g.dart';

@riverpod
class AppInitialization extends _$AppInitialization {
  late Future<void> _firebaseFuture;

  @override
  Future<AppInitState> build() async {
    await SchedulerBinding.instance.endOfFrame;

    _firebaseFuture = _initFirebase();
    _firebaseFuture.ignore();
    NotificationHandler.initialize().ignore();

    if (!SettingsData.hasCompletedOnboarding) {
      await Future.delayed(Duration(seconds: 2));
      return AppInitState.onboarding;
    }

    await _startupPreparation();
    return AppInitState.ready;
  }

  Future<bool> finishOnboarding(OnboardingData onboardingData) async {
    bool didAccept;
    try {
      didAccept = await ref.read(legalHandlerProvider).acceptAll();
    } catch (_) {
      return false;
    }

    if (!didAccept) return false;

    state = AsyncLoading<AppInitState>();
    state = await AsyncValue.guard(() async {
      await _firebaseFuture;
      await Future.wait([
        ref
            .read(nutrientsProvider.notifier)
            .loadFromOnboarding(onboardingData.nutrients),
        ref.read(alimentBankProvider.notifier).load(),
      ]);
      SettingsData.hasCompletedOnboarding = true;
      return AppInitState.ready;
    });

    return true;
  }

  Future<void> _startupPreparation() async {
    await _firebaseFuture;
    await Future.wait([
      ref.read(nutrientsProvider.notifier).load(),
      ref.read(alimentBankProvider.notifier).load(),
    ]);
  }

  Future<void> _initFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseAppCheck.instance.activate(
      providerAndroid:
          kDebugMode ? AndroidDebugProvider() : AndroidPlayIntegrityProvider(),
      providerApple:
          kDebugMode ? AppleDebugProvider() : AppleAppAttestProvider(),
    );
  }
}
