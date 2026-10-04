import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:live_vitalist/core/auth/domain/credential_source.dart';
import 'package:live_vitalist/features/onboarding/presentation/screens/welcome_screen.dart';
import 'package:live_vitalist/features/settings/data/settings_data.dart';
import 'package:live_vitalist/features/settings/presentation/controllers/settings_controller.dart';
import 'package:live_vitalist/features/settings/settings_screen.dart';
import 'package:live_vitalist/l10n/app_localizations.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class _SettingsController extends SettingsController {
  @override
  bool get isFirebase => false;

  @override
  Future<bool> connect(CredentialSource credentials) async => false;
}

Widget _app(Widget screen) => ProviderScope(
      overrides: [
        settingsControllerProvider.overrideWith(_SettingsController.new)
      ],
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: screen),
      ),
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    await SettingsData.init();
  });

  for (final platform in [TargetPlatform.iOS, TargetPlatform.android]) {
    testWidgets('welcome offers Apple only on iOS ($platform)', (tester) async {
      await tester.pumpWidget(_app(const WelcomeScreen()));
      await tester.pumpAndSettle();

      final text = tester
          .widgetList<RichText>(find.byType(RichText))
          .map((widget) => widget.text.toPlainText())
          .join('\n');
      expect(text, contains(platform == TargetPlatform.iOS
          ? 'Sign in with Google or Apple'
          : 'Have an account? Connect with Google instead.'));
      expect(
          text.contains(' or Apple'), platform == TargetPlatform.iOS);
      expect(tester.takeException(), isNull);
    }, variant: TargetPlatformVariant({platform}));

    testWidgets('settings offers Apple only on iOS ($platform)',
        (tester) async {
      await tester.pumpWidget(_app(const SettingsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Connect with Google'), findsOneWidget);
      expect(find.byType(SignInWithAppleButton),
          platform == TargetPlatform.iOS ? findsOneWidget : findsNothing);
      expect(tester.takeException(), isNull);
    }, variant: TargetPlatformVariant({platform}));
  }
}
