import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
// import 'package:firebase_ui_auth/firebase_ui_auth.dart';
// import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

// import 'env.dart';
import 'file_handler.dart';
import 'home_screen.dart';
import 'permission_handler.dart';
import 'settings.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  static Future<void> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return; // user canceled

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

  Future<void> toggleExternal() async {
    if (!StorageHandler.isExternal &&
        await PermissionHandler.requestExternalStorage()) {
      StorageHandler.isExternal = true;
    } else if (StorageHandler.isExternal) {
      StorageHandler.isExternal = false;
    }
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
                    if (StorageHandler.isFirebase) setState(() {});
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
              /* External */
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Checkbox(
                      value: StorageHandler.isExternal,
                      onChanged: (_) =>
                          toggleExternal().then((_) => setState(() {}))),
                  label: const Text("Save data in downloads"),
                  onPressed: () =>
                      toggleExternal().then((_) => setState(() {})),
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
  // Future<void> setLoggedIn() async {
  //   SettingsData.isLoggedIn = true;
  //   await SettingsData.save();
  // }

  // void onGoogle() {
  //   StorageHandler.isFirebase = true;
  // }

  // /* Can be optimised with
  // if((  !SettingsData.isExternal && await PermissionHandler.requestExternalStorage() )
  //       || SettingsData.isExternal  )

  //   SettingsData.isExternal = !SettingsData.isExternal;
  //   */
  // Future<void> enableExternal() async {
  //   if (!SettingsData.isExternal &&
  //       await PermissionHandler.requestExternalStorage()) {
  //     SettingsData.isExternal = true;
  //   } else if (SettingsData.isExternal) {
  //     SettingsData.isExternal = false;
  //   }
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return StreamBuilder<User?>(
  //     stream: FirebaseAuth.instance.authStateChanges(),
  //     builder: (context, snapshot) {
  //       SignInScreen signInScreen() {
  //         return SignInScreen(
  //           providers: [
  //             GoogleProvider(clientId: Env.firebaseGoogleWebClientId),
  //           ],
  //           showAuthActionSwitch: false,
  //           footerBuilder: (context, action) {
  //             return Padding(
  //               padding: const EdgeInsets.only(top: 24.0),
  //               child: Column(
  //                 children: [
  //                   const Text("Or continue without signing in:"),
  //                   const SizedBox(height: 12),
  //                   SizedBox(
  //                     width: double.infinity,
  //                     child: ElevatedButton.icon(
  //                       icon: const Icon(Icons.person_outline),
  //                       label: const Text("Continue locally"),
  //                       onPressed: () async {
  //                         setLoggedIn();
  //                         setState(() {});
  //                       },
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     width: double.infinity,
  //                     child: ElevatedButton.icon(
  //                       icon: Checkbox(
  //                         value: SettingsData.isExternal,
  //                         onChanged: (_) =>
  //                             enableExternal().then((_) => setState(() {})),
  //                       ),
  //                       label: const Text("Save data externally"),
  //                       onPressed: () =>
  //                           enableExternal().then((_) => setState(() {})),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             );
  //           },
  //         );
  //       }

  //       if (SettingsData.isLoggedIn) {
  //         if (snapshot.hasData) {
  //           /* in as google */
  //           onGoogle();
  //           // } else {
  //           /* in as guest */
  //           /* Already verified if external or not in main. */
  //         }
  //       } else {
  //         if (snapshot.hasData) {
  //           /* new google */
  //           setLoggedIn();
  //           onGoogle();
  //         } else {
  //           /* new user */
  //           return signInScreen();
  //         }
  //       }

  //       return const HomeScreen();
  //     },
  //   );
  // }
}
