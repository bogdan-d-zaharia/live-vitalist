import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';

import 'env.dart';
import 'file_handler.dart';
import 'home_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  //TODO: isGuest is not persistent.
  // onGuest is not called every time entering the app. Save it and load it.
  static bool isGuest = false;

  void onGuest() {
    isGuest = true;
  }

  void onGoogle() {
    StorageHandler.isFirebase = true;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData && !isGuest) {
          return SignInScreen(
            providers: [
              GoogleProvider(clientId: Env.firebaseGoogleWebClientId),
            ],
            showAuthActionSwitch: false,
            footerBuilder: (context, action) {
              return Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Column(
                  children: [
                    const Text("Or continue without signing in:"),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.person_outline),
                      label: const Text("Continue as Guest"),
                      onPressed: () async {
                        onGuest();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const HomeScreen()),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        }

        onGoogle();
        return const HomeScreen();
      },
    );
  }
}
