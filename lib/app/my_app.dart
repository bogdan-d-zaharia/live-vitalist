import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/app/routing/app_router.dart';
import 'package:live_vitalist/core/theme/app_colors_theme.dart';
import 'package:live_vitalist/core/theme/app_text_styles_theme.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routerConfig = ref.watch(appRouterProvider);

    return MaterialApp.router(
      routerConfig: routerConfig,
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
    );
  }
}
