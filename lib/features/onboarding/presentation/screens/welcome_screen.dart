import 'package:flutter/foundation.dart';
import 'package:live_vitalist/core/auth/data/apple_credential_source.dart';
import 'package:live_vitalist/core/auth/domain/credential_source.dart';
import 'package:live_vitalist/core/auth/data/google_credential_source.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/core/presentation/widgets/app_logo.dart';
import 'package:live_vitalist/core/presentation/widgets/localized_rich_text.dart';
import 'package:live_vitalist/features/app_initialization/presentation/controllers/app_initialization_provider.dart';
import 'package:live_vitalist/features/onboarding/presentation/widgets/connection_dialog.dart';
import 'package:live_vitalist/l10n/app_localizations.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  bool _isConnecting = false;

  Future<void> _connect(CredentialSource credentials, String provider) async {
    if (_isConnecting) return;
    _isConnecting = true;

    final result =
        await ref.read(appInitializationProvider.notifier).connect(credentials);
    _isConnecting = false;
    if (!mounted) return;

    return switch (result) {
      ConnectionResult.connected ||
      ConnectionResult.cancelled =>
        Future<void>.value(),
      ConnectionResult.accountNotFound => showConnectionDialog(context,
          type: ConnectionDialogType.accountNotFound, provider: provider),
      ConnectionResult.failed => showConnectionDialog(context,
          type: ConnectionDialogType.connectionFailed, provider: provider),
    };
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final showApple = !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
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
            text: showApple
                ? l.welcomeScreenExistingAccountWithApple(
                    '{googleLink}', '{appleLink}')
                : l.welcomeScreenExistingAccount('{googleLink}'),
            replacements: {
              '{googleLink}': TextSpan(
                text: showApple ? 'Google' : l.welcomeScreenGoogleLink,
                style: linkStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = () => _connect(
                      ref.read(googleCredentialSourceProvider), 'Google'),
              ),
              if (showApple)
                '{appleLink}': TextSpan(
                  text: l.welcomeScreenAppleLink,
                  style: linkStyle,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => _connect(
                        ref.read(appleCredentialSourceProvider), 'Apple'),
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
