import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  Widget logInScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authentification'),
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
                  label: Text('Continue locally'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!isLogged) return logInScreen();
    if (isGoogle) StorageHandler.isFirebase = true;

    return const HomeScreen();
  }
}
