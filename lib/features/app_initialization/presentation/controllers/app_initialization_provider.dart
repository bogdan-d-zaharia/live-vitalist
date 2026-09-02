import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:live_vitalist/core/storage/data/sync_service.dart';
import 'package:live_vitalist/features/aliment_bank/data/aliment_bank.dart';
import 'package:live_vitalist/features/app_initialization/domain/app_initialization_state.dart';
import 'package:live_vitalist/features/legal/data/legal_handler.dart';
import 'package:live_vitalist/features/notifications/data/notifications_api.dart';
import 'package:live_vitalist/features/notifications/notification_handler.dart';
import 'package:live_vitalist/features/nutrient/data/nutrient_provider.dart';
import 'package:live_vitalist/features/onboarding/domain/onboarding_data.dart';
import 'package:live_vitalist/features/settings/data/settings_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_initialization_provider.g.dart';

enum GoogleConnectionResult {
  connected,
  cancelled,
  accountNotFound,
  failed,
}

@Riverpod(keepAlive: true)
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

  Future<void> _initFirebase() async {
    await FirebaseAppCheck.instance.activate(
      providerAndroid:
          kDebugMode ? AndroidDebugProvider() : AndroidPlayIntegrityProvider(),
      providerApple:
          kDebugMode ? AppleDebugProvider() : AppleAppAttestProvider(),
    );
  }

  // #region //* REGULAR STARTUP *//
  Future<void> _startupPreparation() async {
    await _firebaseFuture;
    await Future.wait([
      ref.read(nutrientsProvider.notifier).load(),
      ref.read(alimentBankControllerProvider.notifier).load(),
    ]);
  }
  // #endregion

  // #region //* ONBOARDING STARTUP *//
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
        ref.read(alimentBankControllerProvider.notifier).load(),
      ]);
      SettingsData.hasCompletedOnboarding = true;
      return AppInitState.ready;
    });

    return true;
  }
  // #endregion

  // #region //* CONNECT WITH GOOGLE STARTUP *//
  Future<GoogleConnectionResult> connectWithGoogle() async {
    final googleSignIn = GoogleSignIn();

    try {
      await googleSignIn.signOut();
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return GoogleConnectionResult.cancelled;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.additionalUserInfo?.isNewUser == true) {
        try {
          await userCredential.user?.delete();
        } catch (error, stackTrace) {
          _reportGoogleConnectionError(error, stackTrace);
          await _disconnectFromGoogle(googleSignIn);
          return GoogleConnectionResult.failed;
        }
        await _disconnectFromGoogle(googleSignIn);
        return GoogleConnectionResult.accountNotFound;
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
      return GoogleConnectionResult.connected;
    } catch (error, stackTrace) {
      _reportGoogleConnectionError(error, stackTrace);
      await _disconnectFromGoogle(googleSignIn);
      return GoogleConnectionResult.failed;
    }
  }

  void _reportGoogleConnectionError(Object error, StackTrace stackTrace) {
    debugPrint('Google connection failed: $error');
    debugPrintStack(stackTrace: stackTrace);
  }

  Future<void> _disconnectFromGoogle(GoogleSignIn googleSignIn) async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (_) {}

    try {
      await googleSignIn.signOut();
    } catch (_) {}
  }
  // #endregion
}
