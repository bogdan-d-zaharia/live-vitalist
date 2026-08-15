import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/core/theme/app_colors_theme.dart';
import 'package:live_vitalist/core/theme/app_text_styles_theme.dart';
import 'package:live_vitalist/features/authentication/auth_gate.dart';
import 'package:live_vitalist/features/notifications/notification_handler.dart';
import 'package:live_vitalist/features/settings/data/settings_data.dart';
import 'package:live_vitalist/firebase_options.dart';

// Fetching announcements from localhost works
// by using ngrok with the port.

// *** Announcements & Reports ***
// TODO: Make the week result page helpful and make it look good.

// *** Workers & Push Notifications ***
// TODO: Have the user be able to log their meal from the notification
// with a message text field.

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    providerAndroid: kDebugMode
        ? const AndroidDebugProvider()
        : const AndroidPlayIntegrityProvider(),
    providerApple: kDebugMode
        ? const AppleDebugProvider()
        : const AppleAppAttestProvider(),
  );

  await NotificationHandler.initialize();
  await SettingsData.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Live Vitalist',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          extensions: [
            AppColorsTheme.light,
            AppTextStylesTheme.light,
          ],
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
          extensions: [
            AppColorsTheme.dark,
            AppTextStylesTheme.dark,
          ],
        ),
        themeMode: ThemeMode.system,
        home: AuthGate(),
      ),
    );
  }
}
