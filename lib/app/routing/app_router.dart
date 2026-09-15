import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:live_vitalist/app/home_shell.dart';
import 'package:live_vitalist/app/home_screen.dart';
import 'package:live_vitalist/app/routing/app_routes.dart';
import 'package:live_vitalist/app/routing/pages/app_routing_error_screen.dart';
import 'package:live_vitalist/app/routing/pages/super_search_page.dart';
import 'package:live_vitalist/features/app_initialization/domain/app_initialization_state.dart';
import 'package:live_vitalist/features/app_initialization/presentation/app_initialization_error_screen.dart';
import 'package:live_vitalist/features/app_initialization/presentation/controllers/app_initialization_provider.dart';
import 'package:live_vitalist/features/meals_journal/presentation/widgets/meal_editor.dart';
import 'package:live_vitalist/features/onboarding/onboarding_screen.dart';
import 'package:live_vitalist/features/settings/settings_screen.dart';
import 'package:live_vitalist/features/splash_screen/presentation/splash_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  final router = GoRouter(
    initialLocation: AppRoutes.root,
    overridePlatformDefaultLocation: true,
    routes: [
      GoRoute(
        path: AppRoutes.root,
        builder: (_, __) => SplashScreen(),
        routes: [
          GoRoute(
            path: AppRoutes.onboardingPath,
            pageBuilder: (_, state) => CustomTransitionPage(
              key: state.pageKey,
              transitionDuration: Duration(milliseconds: 600),
              reverseTransitionDuration: Duration(milliseconds: 500),
              transitionsBuilder: (_, animation, __, child) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: OnboardingScreen(),
            ),
          ),
        ],
      ),
      ShellRoute(
        pageBuilder: (context, state, child) => CustomTransitionPage(
          key: state.pageKey,
          transitionDuration: Duration(milliseconds: 600),
          reverseTransitionDuration: Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, __, child) {
            return ColoredBox(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: FadeTransition(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeIn,
                ),
                child: child,
              ),
            );
          },
          // TODO: Move isHomeRoute to a provider perhaps.
          child: HomeShell(
            isHomeRoute: state.uri.path == AppRoutes.home,
            isSearchRoute: state.uri.path == AppRoutes.search,
            child: child,
          ),
        ),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            // TODO: Move onOpenSettings, onOpenMeal to providers.
            builder: (context, __) => HomeScreen(
              onOpenSettings: () async {
                await context.push(AppRoutes.settings);
              },
              onOpenMeal: (mealKey, date) async {
                await context.push(
                  AppRoutes.mealEditorLocation(
                    mealKey: mealKey,
                    date: date,
                  ),
                );
              },
            ),
            routes: [
              GoRoute(
                path: AppRoutes.settingsPath,
                builder: (_, __) => SettingsScreen(),
              ),
              GoRoute(
                path: AppRoutes.mealEditorPath,
                builder: (_, state) {
                  final mealKey = state.uri.queryParameters['mealKey'] ??
                      state.uri.queryParameters['mealName'];
                  final date = DateTime.tryParse(
                    state.uri.queryParameters['date'] ?? '',
                  );

                  if (mealKey == null || date == null) {
                    return AppRoutingErrorScreen(
                      error: FormatException(
                        'Meal editor route parameters are invalid.',
                      ),
                    );
                  }

                  return MealEditor(mealKey: mealKey, date: date);
                },
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.search,
            pageBuilder: (_, state) => SuperSearchPage(key: state.pageKey),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.initializationError,
        builder: (_, __) => AppInitializationErrorScreen(),
      ),
    ],
    errorBuilder: (_, state) => AppRoutingErrorScreen(error: state.error),
    redirect: (_, routeState) {
      final initialization = ref.read(appInitializationProvider);
      final isInHomeShell = routeState.matchedLocation == AppRoutes.search ||
          routeState.matchedLocation == AppRoutes.home ||
          routeState.matchedLocation.startsWith('${AppRoutes.home}/');
      final destination = initialization.when(
        loading: () => AppRoutes.root,
        error: (error, stackTrace) {
          FlutterError.reportError(
            FlutterErrorDetails(
              exception: error,
              stack: stackTrace,
              context: ErrorDescription('during app initialization'),
            ),
          );

          return AppRoutes.initializationError;
        },
        data: (initializationState) => switch (initializationState) {
          AppInitState.onboarding => AppRoutes.onboarding,
          AppInitState.ready =>
            isInHomeShell ? routeState.matchedLocation : AppRoutes.home,
        },
      );

      return routeState.matchedLocation == destination ? null : destination;
    },
  );

  ref.listen(appInitializationProvider, (previous, next) {
    final previousState = previous?.asData?.value;
    final nextState = next.asData?.value;

    if (nextState == AppInitState.onboarding &&
        previousState != AppInitState.onboarding) {
      router.push(AppRoutes.onboarding);
      return;
    }

    if (nextState == AppInitState.ready &&
        previousState != AppInitState.ready) {
      router.pushReplacement(AppRoutes.home);
      return;
    }

    router.refresh();
  });
  ref.onDispose(router.dispose);
  return router;
}
