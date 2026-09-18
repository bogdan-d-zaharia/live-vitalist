import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/app/routing/app_router.dart';
import 'package:live_vitalist/core/localization/localization_provider.dart';
import 'package:live_vitalist/core/theme/app_colors_theme.dart';
import 'package:live_vitalist/core/theme/app_text_styles_theme.dart';
import 'package:live_vitalist/core/theme/long_press_action_menu_theme.dart';
import 'package:live_vitalist/core/theme/app_menu_button_theme.dart';
import 'package:live_vitalist/l10n/app_localizations.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routerConfig = ref.watch(appRouterProvider);
    final languageCode = ref.watch(localizationProvider);
    final lightColors = ColorScheme.fromSeed(
        seedColor: Colors.green, brightness: Brightness.light);
    final darkColors = ColorScheme.fromSeed(
        seedColor: Colors.green, brightness: Brightness.dark);
    final menuShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.0),
      side: BorderSide.none,
    );
    final popupMenuTheme = PopupMenuThemeData(
      shape: menuShape,
      elevation: 3.0,
      surfaceTintColor: Colors.transparent,
      menuPadding: EdgeInsets.symmetric(vertical: 4.0),
      textStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
    );
    PopupMenuThemeData themedMenu(ColorScheme colors) =>
        popupMenuTheme.copyWith(
          color: colors.surfaceContainerLow,
          shadowColor: colors.shadow.withValues(alpha: 0.18),
          labelTextStyle: WidgetStateProperty.resolveWith((states) => TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: states.contains(WidgetState.disabled)
                    ? colors.onSurface.withValues(alpha: 0.38)
                    : colors.onSurface,
              )),
        );
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
        shape: WidgetStatePropertyAll(menuShape),
        side: WidgetStatePropertyAll(BorderSide.none),
      ),
    );

    return MaterialApp.router(
      routerConfig: routerConfig,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(languageCode),
      debugShowCheckedModeBanner: false,
      title: 'Live Vitalist',
      theme: ThemeData(
        colorScheme: lightColors,
        useMaterial3: true,
        extensions: [
          AppColorsTheme.light,
          AppTextStylesTheme.light,
          LongPressActionMenuTheme.compact(lightColors),
          AppMenuButtonTheme.subtle(lightColors),
        ],
        dropdownMenuTheme: dropDownMenuTheme,
        popupMenuTheme: themedMenu(lightColors),
      ),
      darkTheme: ThemeData(
        colorScheme: darkColors,
        useMaterial3: true,
        extensions: [
          AppColorsTheme.dark,
          AppTextStylesTheme.dark,
          LongPressActionMenuTheme.compact(darkColors),
          AppMenuButtonTheme.subtle(darkColors),
        ],
        dropdownMenuTheme: dropDownMenuTheme,
        popupMenuTheme: themedMenu(darkColors),
      ),
      themeMode: ThemeMode.system,
    );
  }
}
