import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:live_vitalist/features/onboarding/onboarding_screen.dart';
import 'features/authentication/auth_gate.dart';
import 'features/notifications/notification_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'features/settings/data/settings_data.dart';
import 'core/theme/app_background_theme.dart';
import 'core/theme/app_colors_theme.dart';
import 'core/theme/app_text_styles_theme.dart';

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
    providerAndroid: const AndroidDebugProvider(),
    providerApple: const AppleDebugProvider(),
  );

  await NotificationHandler.initialize();
  await SettingsData.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final searchBarTheme = SearchBarThemeData()
        .copyWith(shadowColor: WidgetStatePropertyAll(Colors.green));
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Live Vitalist',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
            brightness: Brightness.light,
          ),
          searchBarTheme: searchBarTheme,
          useMaterial3: true,
          extensions: [
            AppBackgroundTheme.light,
            AppColorsTheme.light,
            AppTextStylesTheme.light,
          ],
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
            brightness: Brightness.dark,
          ),
          searchBarTheme: searchBarTheme,
          useMaterial3: true,
          extensions: [
            AppBackgroundTheme.dark,
            AppColorsTheme.dark,
            AppTextStylesTheme.dark,
          ],
        ),
        themeMode: ThemeMode.system,
        home: SettingsData.isLoggedIn ? AuthGate() : OnboardingScreen(),
        // home: OnboardingScreen(),
      ),
    );
  }
}
