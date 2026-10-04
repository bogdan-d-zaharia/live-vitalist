import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:live_vitalist/core/auth/domain/credential_source.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

part 'apple_credential_source.g.dart';

@riverpod
CredentialSource appleCredentialSource(Ref ref) => AppleCredentialSource();

/// Native Apple credentials for iOS and macOS.
final class AppleCredentialSource implements CredentialSource {
  String? _authorizationCode;

  @override
  String? get authorizationCode => _authorizationCode;

  @override
  Future<AuthCredential?> getCredential() async {
    _authorizationCode = null;
    final rawNonce = generateNonce();
    final nonce = sha256.convert(utf8.encode(rawNonce)).toString();

    try {
      final account = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName
        ],
        nonce: nonce,
      );
      final idToken = account.identityToken;
      if (idToken == null || idToken.isEmpty) {
        throw StateError('Apple did not return an identity token');
      }
      _authorizationCode = account.authorizationCode;
      return AppleAuthProvider.credentialWithIDToken(
        idToken,
        rawNonce,
        AppleFullPersonName(
          givenName: account.givenName,
          familyName: account.familyName,
        ),
      );
    } on SignInWithAppleAuthorizationException catch (error) {
      if (error.code == AuthorizationErrorCode.canceled) return null;
      rethrow;
    }
  }

  // Apple has no local provider session to sign out of; Firebase owns the session.
  @override
  Future<void> signOut() async {}
}
