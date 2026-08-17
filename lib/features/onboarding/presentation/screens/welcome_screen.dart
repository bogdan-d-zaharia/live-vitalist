import 'package:flutter/material.dart';
import 'package:live_vitalist/core/presentation/widgets/app_logo.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 20.0,
          children: [
            Hero(
              tag: AppLogo.heroTag,
              child: AppLogo(),
            ),
            Text(
              'Welcome to Live Vitalist',
              textAlign: TextAlign.center,
              style: textTheme.headlineSmall,
            ),
            Text(
              "Let's set up your profile so we can tailor your nutrition and fitness journey to you.",
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
