import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/app/routing/app_router.dart';
import 'package:live_vitalist/core/theme/app_colors_theme.dart';
import 'package:live_vitalist/core/theme/app_text_styles_theme.dart';
import 'package:live_vitalist/l10n/app_localizations.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routerConfig = ref.watch(appRouterProvider);
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(24.0),
      borderSide: BorderSide.none,
    );
    final dropDownMenuTheme = DropdownMenuThemeData(
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        // fillColor: Theme.of(context).colorScheme.surfaceContainerLow,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        constraints: BoxConstraints.tightFor(height: 42.0),
        border: border,
      ),
      menuStyle: MenuStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
        ),
        side: WidgetStatePropertyAll(BorderSide.none),
      ),
    );

    return MaterialApp.router(
      routerConfig: routerConfig,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
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
        dropdownMenuTheme: dropDownMenuTheme,
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
        dropdownMenuTheme: dropDownMenuTheme,
      ),
      themeMode: ThemeMode.system,
    );
  }
}
