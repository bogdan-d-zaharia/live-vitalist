import 'package:flutter/material.dart';
import 'package:live_vitalist/core/presentation/widgets/app_logo.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(
          tag: AppLogo.heroTag,
          child: AppLogo(size: 160.0),
        ),
      ),
    );
  }
}
