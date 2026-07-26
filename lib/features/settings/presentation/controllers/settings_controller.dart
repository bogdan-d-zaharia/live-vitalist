import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:live_vitalist/features/notifications/data/notifications_api.dart';
import 'package:live_vitalist/features/settings/data/settings_data.dart';
import 'package:live_vitalist/core/storage/data/storage_provider.dart';
import 'package:live_vitalist/core/storage/data/sync_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_controller.g.dart';

@riverpod
class SettingsController extends _$SettingsController {
  @override
  void build() {}

  bool get isFirebase => FirebaseAuth.instance.currentUser != null;

  Future<bool> connectWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return false;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);

      await ref.read(syncServiceProvider.notifier).lateLogin();
      final userId = FirebaseAuth.instance.currentUser?.uid;

      final String? fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null && userId != null) {
        final api = ref.read(notificationsApiProvider);
        await api.saveToken(userId, fcmToken);
      } else {
        throw Exception("CANNOT RETRIEVE NOTIFICATION CREDENTIALS");
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// The settings are only reset once the user data is actually gone.
  Future<bool> executeDeleteEverything() async {
    final deleted = await ref.read(storageProvider.notifier).deleteEverything();
    if (deleted) await SettingsData.deleteAll();
    return deleted;
  }

  Future<bool> deleteOnlineAccount() {
    return ref.read(storageProvider.notifier).deleteAccount();
  }
}
