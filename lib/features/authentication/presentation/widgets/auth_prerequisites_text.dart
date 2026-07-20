import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthPrerequisitesText extends StatelessWidget {
  const AuthPrerequisitesText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: 'Before using Live Vitalist, please review and accept our ',
        children: [
          TextSpan(
            text: 'Privacy Policy',
            style: TextStyle(
                color: Colors.blue, decoration: TextDecoration.underline),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                final url = Uri.parse(
                    'https://live-vitalist.notion.site/Privacy-Policy-Live-Vitalist-1d612e3b9fc280d1be5cd9a718709560');
                await launchUrl(url, mode: LaunchMode.externalApplication);
              },
          ),
          TextSpan(text: ' and '),
          TextSpan(
            text: 'Terms of Use',
            style: TextStyle(
                color: Colors.blue, decoration: TextDecoration.underline),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                final url = Uri.parse(
                    'https://live-vitalist.notion.site/Terms-of-Use-Live-Vitalist-1d612e3b9fc28053a196f93d6c739858');
                await launchUrl(url, mode: LaunchMode.externalApplication);
              },
          ),
          TextSpan(text: '.'),
        ],
      ),
      textAlign: TextAlign.start,
    );
  }
}
