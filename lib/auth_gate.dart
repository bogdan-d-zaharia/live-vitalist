import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';

import 'custom_card.dart';
import 'file_handler.dart';
import 'home_screen.dart';
import 'settings.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  static Future<void> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return; /* user canceled */

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);

    StorageHandler.isFirebase = true;
  }

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool get isGoogle => FirebaseAuth.instance.currentUser != null;
  bool get isLogged => SettingsData.isLoggedIn;

  Future<void> setLoggedIn() async {
    SettingsData.isLoggedIn = true;
    await SettingsData.save();
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
                          onPressed: () => Navigator.pop(context, true),
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

  Widget logInScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authentication'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /* Google */
              Text('Backup your data to cloud by signing with Google.'),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await AuthGate.signInWithGoogle();
                    if (StorageHandler.isFirebase) {
                      await setLoggedIn();
                      setState(() {});
                    }
                  },
                  label: Text('Sign in with Google'),
                ),
              ),
              SizedBox(height: 16.0),
              /* Local */
              Text('Or continue by only saving it locally.'),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await setLoggedIn();
                    setState(() {});
                  },
                  label: Text('Continue locally as guest'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    if (isLogged) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showPrivacyPolicyAndTermsOfUsePopup();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isLogged) return logInScreen();
    if (isGoogle) StorageHandler.isFirebase = true;

    return const HomeScreen();
  }
}
