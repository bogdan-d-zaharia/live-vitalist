import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:live_vitalist/core/presentation/widgets/localized_rich_text.dart';
import 'package:live_vitalist/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class LegalPrerequisitesText extends StatelessWidget {
  const LegalPrerequisitesText({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return LocalizedRichText(
      text: l.legalPrerequisites('{privacyLink}', '{termsLink}'),
      replacements: {
        '{privacyLink}': TextSpan(
            text: l.legalPrivacyPolicy,
            style: TextStyle(
                color: Colors.blue, decoration: TextDecoration.underline),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                final url = Uri.parse(
                    'https://live-vitalist.notion.site/Privacy-Policy-Live-Vitalist-1d612e3b9fc280d1be5cd9a718709560');
                await launchUrl(url, mode: LaunchMode.externalApplication);
              },
          ),
        '{termsLink}': TextSpan(
            text: l.legalTermsOfUse,
            style: TextStyle(
                color: Colors.blue, decoration: TextDecoration.underline),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                final url = Uri.parse(
                    'https://live-vitalist.notion.site/Terms-of-Use-Live-Vitalist-1d612e3b9fc28053a196f93d6c739858');
                await launchUrl(url, mode: LaunchMode.externalApplication);
              },
          ),
      },
      textAlign: TextAlign.start,
    );
  }
}
