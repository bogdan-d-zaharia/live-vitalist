import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/core/presentation/widgets/app_logo.dart';
import 'package:live_vitalist/core/presentation/widgets/localized_rich_text.dart';
import 'package:live_vitalist/features/app_initialization/presentation/controllers/app_initialization_provider.dart';
import 'package:live_vitalist/features/onboarding/presentation/widgets/google_connection_dialog.dart';
import 'package:live_vitalist/l10n/app_localizations.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  bool _isConnectingWithGoogle = false;

  Future<void> _connectWithGoogle() async {
    if (_isConnectingWithGoogle) return;
    _isConnectingWithGoogle = true;

    final result = await ref
        .read(appInitializationProvider.notifier)
        .connectWithGoogle();
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
