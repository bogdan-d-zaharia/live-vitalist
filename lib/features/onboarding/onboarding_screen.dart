import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/features/onboarding/presentation/controllers/onboarding_controller.dart';
import 'package:live_vitalist/features/onboarding/presentation/screens/goal_screen.dart';
import 'package:live_vitalist/features/onboarding/presentation/screens/nutrients_screen.dart';
import 'package:live_vitalist/features/onboarding/presentation/screens/streak_screen.dart';
import 'package:live_vitalist/features/onboarding/presentation/screens/terms_screen.dart';
import 'package:live_vitalist/features/onboarding/presentation/screens/welcome_screen.dart';
import 'package:live_vitalist/features/onboarding/presentation/widgets/animated_navigation_buttons.dart';
import 'package:live_vitalist/features/onboarding/presentation/widgets/completion_widget.dart';
import 'package:live_vitalist/features/onboarding/presentation/widgets/no_connection_dialog.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  final Future<bool> Function() acceptLegal;
  const OnboardingScreen({super.key, required this.acceptLegal});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pages = [
    WelcomeScreen(),
    GoalScreen(),
    NutrientsScreen(),
    StreakScreen(),
    TermsScreen(),
  ];

  final _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _tryFinish() async {
    final isAccepted = await widget.acceptLegal();
    if (!mounted) return;

    if (isAccepted) {
      Navigator.pop(context, true);
    } else {
      ref.read(onboardingControllerProvider.notifier).previousStep();
      await showNoConnectionDialog(context);
    }
  }

  /// A step past the last one available means the onboarding is over.
  void _onStepChanged(int step) {
    if (step >= _pages.length) {
      _tryFinish();
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

    return PopScope(
      canPop: stepIndex == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        controllerNotifier.previousStep();
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: NeverScrollableScrollPhysics(),
                  children: _pages,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                child: AnimatedNavigationButtons(
                  showBackButton: stepIndex > 0,
                  onNext: controllerNotifier.nextStep,
                  onPrevious: controllerNotifier.previousStep,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
