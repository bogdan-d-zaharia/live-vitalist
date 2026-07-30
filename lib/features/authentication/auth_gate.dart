import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/features/authentication/presentation/controllers/auth_controller.dart';
import 'package:live_vitalist/features/legal/data/legal_handler.dart';
import 'package:live_vitalist/features/legal/legal_dialog.dart';
import 'package:live_vitalist/home_screen.dart';

class AuthGate extends ConsumerStatefulWidget {
  const AuthGate({super.key});

  @override
  ConsumerState<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends ConsumerState<AuthGate> {
  Future<void> showPrivacyPolicyAndTermsOfUsePopup() async {
    final requirements = await ref.read(legalHandlerProvider).fetch();
    if (!mounted) return;
    final isAccepted = await showLegalDialog(context, requirements);
    if (isAccepted) {
      ref.read(authControllerProvider.notifier).accept();
    }
  }

  void enterHomeScreen() {
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false,
      );
    }
  }

  void onListen(AuthorizationEnum next) {
    return switch (next) {
      AuthorizationEnum.accepted => enterHomeScreen(),
      AuthorizationEnum.required => showPrivacyPolicyAndTermsOfUsePopup(),
    };
  }

  // TODO: De ce se intampla bug-ul cu ANR-ul si de ce nu se mai intampla?
  // @override
  // void initState() {
  //   super.initState();
  //   print("+++ AuthGate a fost instantiat!");
  // }

  // @override
  // void dispose() {
  //   print("--- AuthGate a fost distrus!");
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // listen just executes actions when a value changes,
    // it does not redraw (rebuild) the widget.
    ref.listen<AsyncValue<AuthorizationEnum>>(
      authControllerProvider,
      (previous, next) => next.whenOrNull(data: onListen),
    );
    return Scaffold();
  }
}
