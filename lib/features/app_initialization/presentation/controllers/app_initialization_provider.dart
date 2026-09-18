import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:live_vitalist/core/auth/domain/credential_source.dart';
import 'package:live_vitalist/core/storage/data/sync_service.dart';
import 'package:live_vitalist/features/aliment_bank/data/aliment_bank.dart';
import 'package:live_vitalist/features/app_initialization/domain/app_initialization_state.dart';
import 'package:live_vitalist/features/legal/data/legal_handler.dart';
import 'package:live_vitalist/features/notifications/data/notifications_api.dart';
import 'package:live_vitalist/features/notifications/notification_handler.dart';
import 'package:live_vitalist/features/nutrient/data/nutrient_provider.dart';
import 'package:live_vitalist/features/onboarding/domain/onboarding_data.dart';
import 'package:live_vitalist/features/settings/data/settings_data.dart';
import 'package:live_vitalist/firebase_options.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_initialization_provider.g.dart';

enum ConnectionResult {
  connected,
  cancelled,
  accountNotFound,
  failed,
}

@Riverpod(keepAlive: true)
class AppInitialization extends _$AppInitialization {
  late Future<void> _firebaseFtr;

  @override
  Future<AppInitState> build() async {
    final stopwatch = Stopwatch()..start();
    try {
      _firebaseFtr = _initFirebase()..ignore();
      _initAppCheck().ignore();
      NotificationHandler.initialize().ignore();

      await SchedulerBinding.instance.endOfFrame;
      if (!SettingsData.hasCompletedOnboarding) {
        await Future.delayed(Duration(seconds: 2));
        return AppInitState.onboarding;
      }

      await _startupPreparation();
      return AppInitState.ready;
    } finally {
      stopwatch.stop();
      debugPrint('[ LAUNCH OPTIMIZATION ] ${stopwatch.elapsedMilliseconds}');
    }
  }

  Future<void> _initFirebase() async {
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

  Future<void> _initAppCheck() async {
    await _firebaseFtr;
    await FirebaseAppCheck.instance.activate(
      providerAndroid:
          kDebugMode ? AndroidDebugProvider() : AndroidPlayIntegrityProvider(),
      providerApple:
          kDebugMode ? AppleDebugProvider() : AppleAppAttestProvider(),
    );
  }

  // #region //* REGULAR STARTUP *//
  Future<void> _startupPreparation() async {
    await _firebaseFtr;
    await Future.wait([
      ref.read(alimentBankControllerProvider.notifier).load(),
    ]);
  }
  // #endregion

  // #region //* ONBOARDING STARTUP *//
  Future<void> _prepareNutrientConfig(OnboardingData data) async {
    final headers = await ref.read(nutrientConfigsListProvider.future);
    await ref
        .read(nutrientConfigProvider(headers.first.id).notifier)
        .loadFromOnboarding(data.nutrients);
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
      await _firebaseFtr;
      await Future.wait([
        _prepareNutrientConfig(onboardingData),
        ref.read(alimentBankControllerProvider.notifier).load(),
      ]);
      SettingsData.hasCompletedOnboarding = true;
      return AppInitState.ready;
    });

    return true;
  }
  // #endregion

  // #region //* CONNECT STARTUP *//
  Future<ConnectionResult> connect(CredentialSource credentials) async {
    try {
      await credentials.signOut();
      final credential = await credentials.getCredential();
      if (credential == null) return ConnectionResult.cancelled;
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.additionalUserInfo?.isNewUser == true) {
        try {
          final authorizationCode = credentials.authorizationCode;
          if (authorizationCode != null) {
            await FirebaseAuth.instance
                .revokeTokenWithAuthorizationCode(authorizationCode);
          }
          await userCredential.user?.delete();
        } catch (error, stackTrace) {
          _reportConnectionError(error, stackTrace);
          await _disconnect(credentials);
          return ConnectionResult.failed;
        }
        await _disconnect(credentials);
        return ConnectionResult.accountNotFound;
      }

      await _startupPreparation();
      await ref.read(syncServiceProvider.notifier).lateLogin();
      final userId = FirebaseAuth.instance.currentUser?.uid;
      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (userId == null || fcmToken == null) {
        throw Exception("CANNOT RETRIEVE NOTIFICATION CREDENTIALS");
      }

      await ref.read(notificationsApiProvider).saveToken(userId, fcmToken);
      SettingsData.hasCompletedOnboarding = true;
      state = AsyncData(AppInitState.ready);
      return ConnectionResult.connected;
    } catch (error, stackTrace) {
      _reportConnectionError(error, stackTrace);
      await _disconnect(credentials);
      return ConnectionResult.failed;
    }
  }

  void _reportConnectionError(Object error, StackTrace stackTrace) {
    debugPrint('Connection failed: $error');
    debugPrintStack(stackTrace: stackTrace);
  }

  Future<void> _disconnect(CredentialSource credentials) async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (_) {}

    try {
      await credentials.signOut();
    } catch (_) {}
  }
  // #endregion
}
