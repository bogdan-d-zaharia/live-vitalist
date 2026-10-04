import 'package:firebase_auth/firebase_auth.dart';

/// Supplies credentials; Firebase owns the account and session.
abstract interface class CredentialSource {
  /// Returns null when the user cancels authentication.
  Future<AuthCredential?> getCredential();

  /// Latest authorization code, used by Firebase to revoke Apple tokens.
  String? get authorizationCode;

  Future<void> signOut();
}
