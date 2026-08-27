import 'package:flutter/material.dart';
import 'package:live_vitalist/features/super_search/presentation/widgets/super_search_bar_overlay.dart';

class HomeShell extends StatelessWidget {
  final Widget child;
  final bool isHomeRoute;
  final bool isSearchRoute;

  const HomeShell({
    super.key,
    required this.child,
    required this.isHomeRoute,
    required this.isSearchRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          child,
          SuperSearchBarOverlay(
            isHomeRoute: isHomeRoute,
            isSearchRoute: isSearchRoute,
          ),
        ],
      ),
    );
  }
}
