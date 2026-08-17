import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:live_vitalist/features/app_initialization/domain/app_initialization_state.dart';
import 'package:live_vitalist/features/app_initialization/presentation/app_initialization_error_screen.dart';
import 'package:live_vitalist/features/app_initialization/presentation/controllers/app_initialization_provider.dart';
import 'package:live_vitalist/features/onboarding/onboarding_screen.dart';
import 'package:live_vitalist/features/splash_screen/presentation/splash_screen.dart';
import 'package:live_vitalist/app/home_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

abstract final class AppRoutes {
  static const root = '/';
  static const onboarding = '/onboarding';
  static const onboardingPath = 'onboarding';
  static const home = '/home';
  static const initializationError = '/initialization-error';
}

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
              transitionDuration: Duration(milliseconds: 1400),
              reverseTransitionDuration: Duration(milliseconds: 500),
              transitionsBuilder: (_, animation, __, child) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: OnboardingScreen(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.home,
        pageBuilder: (_, state) => CustomTransitionPage(
          key: state.pageKey,
          transitionDuration: Duration(milliseconds: 1600),
          reverseTransitionDuration: Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, __, child) {
            return ColoredBox(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: FadeTransition(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInCubic,
                ),
                child: child,
              ),
            );
          },
          child: HomeScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.initializationError,
        builder: (_, __) => AppInitializationErrorScreen(),
      ),
    ],
    errorBuilder: (_, state) => AppRoutingErrorScreen(error: state.error),
    redirect: (_, state) {
      final initialization = ref.read(appInitializationProvider);
      final destination = initialization.when(
        loading: () => AppRoutes.root,
        error: (_, __) => AppRoutes.initializationError,
        data: (state) => switch (state) {
          AppInitState.onboarding => AppRoutes.onboarding,
          AppInitState.ready => AppRoutes.home,
        },
      );

      return state.matchedLocation == destination ? null : destination;
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

class AppRoutingErrorScreen extends StatelessWidget {
  const AppRoutingErrorScreen({super.key, this.error});

  final Exception? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(
              error == null
                  ? 'The requested page could not be opened.'
                  : 'The requested page could not be opened:\n$error',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
