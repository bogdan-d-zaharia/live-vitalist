import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:live_vitalist/settings_data.dart';
import 'package:live_vitalist/storage/data/sync_service.dart';
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

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> executeDeleteEverything() async {
    await SettingsData.deleteAll();
  }

  Future<void> deleteOnlineAccount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final googleUser = await GoogleSignIn().signIn();
    final googleAuth = await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    await user.reauthenticateWithCredential(credential);

    await user.delete();
  }
}
