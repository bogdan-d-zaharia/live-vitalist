import 'package:firebase_auth/firebase_auth.dart';
import 'package:live_vitalist/core/auth/domain/credential_source.dart';
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

  Future<bool> connect(CredentialSource credentials) async {
    try {
      final credential = await credentials.getCredential();
      if (credential == null) return false;
      await FirebaseAuth.instance.signInWithCredential(credential);

      await ref.read(syncServiceProvider.notifier).lateLogin();
      await ref.read(notificationsApiProvider).registerDevice();

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
