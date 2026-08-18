import 'package:flutter/material.dart';
import 'package:live_vitalist/features/super_search/presentation/super_search_screen.dart';

class HomeShell extends StatelessWidget {
  final Widget child;
  final bool isHomeRoute;

  const HomeShell({
    super.key,
    required this.child,
    required this.isHomeRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          child,
          SuperSearchScreen(isHomeRoute: isHomeRoute),
        ],
      ),
    );
  }
}
