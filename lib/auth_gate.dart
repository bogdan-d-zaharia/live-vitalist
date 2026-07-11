import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/aliment/aliment_bank.dart';
import 'package:live_vitalist/custom_card.dart';
import 'package:live_vitalist/home_screen.dart';
import 'package:live_vitalist/nutrient/nutrient_provider.dart';
import 'package:live_vitalist/settings_data.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthGate extends ConsumerStatefulWidget {
  const AuthGate({super.key});

  @override
  ConsumerState<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends ConsumerState<AuthGate> {
  bool get isGoogle => FirebaseAuth.instance.currentUser != null;
  bool get isLogged => SettingsData.isLoggedIn;

  Future<void> onEnter() async {
    SettingsData.isLoggedIn = true;

    await Future.microtask(() => ref.read(nutrientsProvider.notifier).load());
    await Future.microtask(() => ref.read(alimentBankProvider.notifier).load());

    if (mounted) {
      await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false,
      );
    }
  }

  void showPrivacyPolicyAndTermsOfUsePopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Please Accept Our Terms',
                    style: TextStyle(fontSize: 24.0),
                  ),
                  SizedBox(height: 12.0),
                  Text.rich(
                    TextSpan(
                      text:
                          'Before using Live Vitalist, please review and accept our ',
                      children: [
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final url = Uri.parse(
                                  'https://live-vitalist.notion.site/Privacy-Policy-Live-Vitalist-1d612e3b9fc280d1be5cd9a718709560');
                              await launchUrl(url,
                                  mode: LaunchMode.externalApplication);
                            },
                        ),
                        TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Terms of Use',
                          style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final url = Uri.parse(
                                  'https://live-vitalist.notion.site/Terms-of-Use-Live-Vitalist-1d612e3b9fc28053a196f93d6c739858');
                              await launchUrl(url,
                                  mode: LaunchMode.externalApplication);
                            },
                        ),
                        TextSpan(text: '.'),
                      ],
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                      'You can review the Privacy Policy and Terms of Use at any time from the app\'s Settings, accessible via the ⋮ menu in the top-right corner.'),
                  SizedBox(height: 12.0),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 120.0,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Closing the app...'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                            await Future.delayed(Duration(seconds: 3));
                            SystemNavigator.pop();
                          },
                          icon:
                              Icon(Icons.cancel_outlined, color: Colors.white),
                          label: Text("Exit App"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.0),
                      SizedBox(
                        width: 120.0,
                        child: ElevatedButton.icon(
                          onPressed: onEnter,
                          label: Text("I Agree"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                          ),
                        ),
                      ),
                      SizedBox(width: 6.0),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isLogged) {
        onEnter();
      } else {
        showPrivacyPolicyAndTermsOfUsePopup();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
