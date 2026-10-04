import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:live_vitalist/core/auth/data/apple_credential_source.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  const channel =
      MethodChannel('com.aboutyou.dart_packages.sign_in_with_apple');
  final messenger = binding.defaultBinaryMessenger;

  tearDown(() => messenger.setMockMethodCallHandler(channel, null));

  test('passes the nonce hash to Apple and the fresh raw nonce to Firebase',
      () async {
    final hashes = <String>[];
    messenger.setMockMethodCallHandler(channel, (call) async {
      expect(call.method, 'performAuthorizationRequest');
      final request = (call.arguments as List).single as Map;
      hashes.add(request['nonce'] as String);
      return {
        'type': 'appleid',
        'authorizationCode': 'code',
        'identityToken': 'token',
        'givenName': 'Alex',
      };
    });
    final source = AppleCredentialSource();

    for (var i = 0; i < 2; i++) {
      final credential = await source.getCredential() as OAuthCredential;
      expect(source.authorizationCode, 'code');
      expect(credential.providerId, 'apple.com');
      expect(credential.idToken, 'token');
      expect(credential.appleFullPersonName?.givenName, 'Alex');
      expect(sha256.convert(utf8.encode(credential.rawNonce!)).toString(),
          hashes[i]);
    }
    expect(hashes[0], isNot(hashes[1]));
  });

  test('cancellation returns null', () async {
    messenger.setMockMethodCallHandler(channel, (_) async {
      throw PlatformException(code: 'authorization-error/canceled');
    });
    expect(await AppleCredentialSource().getCredential(), isNull);
  });

  test('missing identity token fails instead of returning a credential',
      () async {
    messenger.setMockMethodCallHandler(
        channel,
        (_) async => {
              'type': 'appleid',
              'authorizationCode': 'code',
            });
    await expectLater(
        AppleCredentialSource().getCredential(), throwsStateError);
  });

  test('authorization failures are not treated as cancellation', () async {
    messenger.setMockMethodCallHandler(channel, (_) async {
      throw PlatformException(code: 'authorization-error/failed');
    });
    await expectLater(
      AppleCredentialSource().getCredential(),
      throwsA(isA<SignInWithAppleAuthorizationException>()),
    );
  });
}
