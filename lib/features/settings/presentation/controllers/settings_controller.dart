import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:live_vitalist/features/settings/data/settings_data.dart';
import 'package:live_vitalist/core/storage/data/storage_provider.dart';
import 'package:live_vitalist/core/storage/data/sync_service.dart';
import 'package:live_vitalist/env.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_controller.g.dart';

@riverpod
class SettingsController extends _$SettingsController {
  @override
  void build() {}

  bool get isFirebase => FirebaseAuth.instance.currentUser != null;

  // TODO: Http/API handler
  Future<void> saveToken(String fcmToken, String userId) async {
    final url = Uri.parse('$apiUrl/save-token');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fcmToken': fcmToken,
          'userId': userId,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

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
        await saveToken(fcmToken, userId);
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
