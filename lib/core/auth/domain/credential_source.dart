import 'package:firebase_auth/firebase_auth.dart';

/// Supplies credentials; Firebase owns the account and session.
abstract interface class CredentialSource {
  /// Returns null when the user cancels authentication.
  Future<AuthCredential?> getCredential();

  Future<void> signOut();
}
