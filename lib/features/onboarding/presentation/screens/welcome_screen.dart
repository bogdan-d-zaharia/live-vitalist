import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:live_vitalist/core/presentation/widgets/app_logo.dart';
import 'package:live_vitalist/core/presentation/widgets/localized_rich_text.dart';
import 'package:live_vitalist/core/storage/data/sync_service.dart';
import 'package:live_vitalist/features/app_initialization/presentation/controllers/app_initialization_provider.dart';
import 'package:live_vitalist/features/notifications/data/notifications_api.dart';
import 'package:live_vitalist/features/onboarding/presentation/widgets/google_connection_dialog.dart';
import 'package:live_vitalist/features/settings/data/settings_data.dart';
import 'package:live_vitalist/l10n/app_localizations.dart';

enum GoogleConnectionResult {
  connected,
  cancelled,
  accountNotFound,
  failed,
}

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  bool _isConnectingWithGoogle = false;

  // TODO: An Authentication system, with both Google and Apple.
  // SignInMethod - an enum
  // authProvider - .signInExisting(method), .signInOrCreate(method), .signOut, .deleteAccount, .reauthenticate, etc.
  // this will be used by / be a wrapper of FirebaseAuth, and will easily expand for SupaBase.
  Future<void> _disconnectFromGoogle(GoogleSignIn googleSignIn) async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (_) {}

    try {
      await googleSignIn.signOut();
    } catch (_) {}
  }

  Future<GoogleConnectionResult> _connectExistingGoogleAccount() async {
    final googleSignIn = GoogleSignIn();

    try {
      await googleSignIn.signOut();
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return GoogleConnectionResult.cancelled;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.additionalUserInfo?.isNewUser == true) {
        try {
          await userCredential.user?.delete();
        } catch (_) {
          await _disconnectFromGoogle(googleSignIn);
          return GoogleConnectionResult.failed;
        }
        await _disconnectFromGoogle(googleSignIn);
        return GoogleConnectionResult.accountNotFound;
      }

      await ref.read(syncServiceProvider.notifier).lateLogin();
      final userId = FirebaseAuth.instance.currentUser?.uid;
      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (userId == null || fcmToken == null) {
        throw Exception("CANNOT RETRIEVE NOTIFICATION CREDENTIALS");
      }

      await ref.read(notificationsApiProvider).saveToken(userId, fcmToken);
      SettingsData.hasCompletedOnboarding = true;
      ref.invalidate(appInitializationProvider);
      return GoogleConnectionResult.connected;
    } catch (_) {
      await _disconnectFromGoogle(googleSignIn);
      return GoogleConnectionResult.failed;
    }
  }

  Future<void> _connectWithGoogle() async {
    if (_isConnectingWithGoogle) return;
    _isConnectingWithGoogle = true;

    final result = await _connectExistingGoogleAccount();
    _isConnectingWithGoogle = false;
    if (!mounted) return;

    switch (result) {
      case GoogleConnectionResult.connected:
      case GoogleConnectionResult.cancelled:
        return;
      case GoogleConnectionResult.accountNotFound:
        await showGoogleConnectionDialog(
          context,
          type: GoogleConnectionDialogType.accountNotFound,
        );
        return;
      case GoogleConnectionResult.failed:
        await showGoogleConnectionDialog(
          context,
          type: GoogleConnectionDialogType.connectionFailed,
        );
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final linkStyle = TextStyle(
      color: colorScheme.primary,
      decoration: TextDecoration.underline,
      decorationColor: colorScheme.primary,
    );

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 20.0,
                children: [
                  Hero(
                    tag: AppLogo.heroTag,
                    child: AppLogo(),
                  ),
                  Text(
                    l.welcomeScreenTitle,
                    textAlign: TextAlign.center,
                    style: textTheme.headlineSmall,
                  ),
                  Text(
                    l.welcomeScreenSubtitle,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          LocalizedRichText(
            text: l.welcomeScreenExistingAccount('{googleLink}'),
            replacements: {
              '{googleLink}': TextSpan(
                text: l.welcomeScreenGoogleLink,
                style: linkStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = _connectWithGoogle,
              ),
            },
            style: textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
