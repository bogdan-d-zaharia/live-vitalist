import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:live_vitalist/core/utils/json_handler.dart';
import 'package:live_vitalist/core/storage/domain/storage_interfaces.dart';

/// Verifies if the user is connected when used.
///
/// A connected user stays non-null even when there is no internet connection.
final class FirebaseHandler implements IStorageHandler, ICloudDeletion {
  @override
  Future<bool> saveJson(String path, Map<String, dynamic> json) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return true;

    final uid = user.uid;
    final db = FirebaseDatabase.instance.ref();

    /* Just waits until it has internet connection and sends. 
       If there is no internet connection, it waits, no exceptions given. */
    await db.child('users/$uid/$path').update(json);

    return true;
  }

  @override
  Future<Map<String, dynamic>?> loadJson(String path) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final uid = user.uid;
    final db = FirebaseDatabase.instance.ref();

    final snapshot = await db.child('users/$uid/$path').get();

    if (snapshot.exists && snapshot.value != null) {
      return (JsonHandler.reverseMapToListRecursive(snapshot.value) as Map)
          .map<String, dynamic>((key, value) => MapEntry(key as String, value));
    }

    return null;
  }

  @override
  Future<bool> deleteAccount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return true;

    try {
      final googleUser = await GoogleSignIn().signIn();
      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await user.reauthenticateWithCredential(credential);
      await FirebaseDatabase.instance.ref('users/${user.uid}').remove();
      await user.delete();

      return true;
    } catch (e) {
      return false;
    }
  }
}
