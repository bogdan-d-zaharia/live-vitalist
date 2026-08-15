import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsScreen extends ConsumerWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              child: Text(
                "You're all set",
                textAlign: TextAlign.center,
                style: textTheme.headlineSmall,
              ),
            ),
          ),
          Text.rich(
            TextSpan(
              text: 'If you continue, you agree with our ',
              style: textTheme.bodyMedium,
              children: [
                TextSpan(
                  text: 'Terms and Conditions',
                  style: linkStyle,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      final url = Uri.parse(
                          'https://live-vitalist.notion.site/Terms-of-Use-Live-Vitalist-1d612e3b9fc28053a196f93d6c739858');
                      await launchUrl(url,
                          mode: LaunchMode.externalApplication);
                    },
                ),
                TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: linkStyle,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      final url = Uri.parse(
                          'https://live-vitalist.notion.site/Privacy-Policy-Live-Vitalist-1d612e3b9fc280d1be5cd9a718709560');
                      await launchUrl(url,
                          mode: LaunchMode.externalApplication);
                    },
                ),
                TextSpan(text: '.'),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
