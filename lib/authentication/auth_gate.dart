import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/authentication/presentation/controllers/auth_controller.dart';
import 'package:live_vitalist/authentication/presentation/widgets/auth_privacy_policy_dialog.dart';
import 'package:live_vitalist/home_screen.dart';

class AuthGate extends ConsumerStatefulWidget {
  const AuthGate({super.key});

  @override
  ConsumerState<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends ConsumerState<AuthGate> {
  void showPrivacyPolicyAndTermsOfUsePopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AuthPrivacyPolicyDialog(
          onEnter: () {
            Navigator.pop(context);
            ref.read(authControllerProvider.notifier).accept();
          },
        );
      },
    );
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
