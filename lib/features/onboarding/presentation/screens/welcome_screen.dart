import 'package:flutter/material.dart';
import 'package:live_vitalist/core/theme/custom_icons.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const List<Color> _logoGradientColors = [
    Color(0xFF119033),
    Color(0xFF64B724),
    Color(0xFF98D02F),
  ];

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
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                stops: [0.25, 0.5, 0.75],
                colors: _logoGradientColors,
              ).createShader(bounds),
              child: Icon(
                CustomIcons.logo,
                size: 128.0,
                color: Colors.white,
                shadows: [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.5),
                    blurRadius: 8.0,
                    offset: Offset(0.0, 2.0),
                  ),
                ],
              ),
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
