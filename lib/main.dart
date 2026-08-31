import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/app/my_app.dart';
import 'package:live_vitalist/features/settings/data/settings_data.dart';

// Fetching announcements from localhost works
// by using ngrok with the port.

// *** Announcements & Reports ***
// TODO: Make the week result page helpful and make it look good.

// *** Workers & Push Notifications ***
// TODO: Have the user be able to log their meal from the notification
// with a message text field.

// TODO: Bug: Closing super search with gesture after closing the meal selector closes the app

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SettingsData.init();

  runApp(ProviderScope(child: MyApp()));
}
