import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:live_vitalist/core/auth/domain/credential_source.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'google_credential_source.g.dart';

@riverpod
CredentialSource googleCredentialSource(Ref ref) => GoogleCredentialSource();

final class GoogleCredentialSource implements CredentialSource {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  String? get authorizationCode => null;

  @override
  Future<AuthCredential?> getCredential() async {
    final account = await _googleSignIn.signIn();
    if (account == null) return null;
    final authentication = await account.authentication;
    return GoogleAuthProvider.credential(
      accessToken: authentication.accessToken,
      idToken: authentication.idToken,
    );
  }

  @override
  Future<void> signOut() => _googleSignIn.signOut();
}
