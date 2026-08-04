import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/features/authentication/auth_gate.dart';
import 'package:live_vitalist/features/onboarding/domain/onboarding_step.dart';
import 'package:live_vitalist/features/onboarding/presentation/controllers/onboarding_controller.dart';
import 'package:live_vitalist/features/onboarding/presentation/screens/goal_screen.dart';
import 'package:live_vitalist/features/onboarding/presentation/screens/nutrients_screen.dart';
import 'package:live_vitalist/features/onboarding/presentation/screens/streak_screen.dart';
import 'package:live_vitalist/features/onboarding/presentation/widgets/completion_widget.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pages = OnboardingStep.values
      .map<Widget>(
        (step) => switch (step) {
          OnboardingStep.goal => const GoalScreen(),
          OnboardingStep.nutrients => const NutrientsScreen(),
          OnboardingStep.streak => const StreakScreen(),
        },
      )
      .toList();

  final _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _enterApp() {
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => AuthGate()),
      (route) => false,
    );
  }

  /// A step past the last one available means the onboarding is over.
  void _onStepChanged(int step) {
    if (step >= _pages.length) {
      _enterApp();
      return;
    }

    _pageController.animateToPage(
      step,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final indexProvider =
        onboardingControllerProvider.select((state) => state.stepIndex);
    final stepIndex = ref.watch(indexProvider);
    ref.listen(indexProvider, (_, next) => _onStepChanged(next));
    final controllerNotifier = ref.read(onboardingControllerProvider.notifier);

    final borderRadius = BorderRadius.circular(16.0);
    final colorScheme = Theme.of(context).colorScheme;

    return PopScope(
      canPop: stepIndex == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        controllerNotifier.previousStep();
      },
      child: Scaffold(
        floatingActionButton: Ink(
          width: 56.0,
          height: 56.0,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: colorScheme.onPrimaryContainer,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.lerp(colorScheme.onPrimaryContainer,
                    colorScheme.onInverseSurface, 0.2)!,
                Color.lerp(colorScheme.onPrimaryContainer,
                    colorScheme.onSurface, 0.2)!,
              ],
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 12.0,
                offset: Offset(0.0, 4.0),
                color: colorScheme.shadow.withValues(alpha: 0.5),
              ),
            ],
          ),
          child: InkWell(
            highlightColor: colorScheme.primary,
            onTap: controllerNotifier.nextStep,
            borderRadius: borderRadius,
            child: Icon(
              Icons.arrow_forward_rounded,
              color: colorScheme.onSecondary,
            ),
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: controllerNotifier.nextStep,
        //   child: Icon(Icons.arrow_forward),
        // ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: _pages,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 128.0,
                  height: 6.0,
                  child: CompletionWidget(
                    count: _pages.length,
                    index: stepIndex,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
