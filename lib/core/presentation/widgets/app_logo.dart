import 'package:flutter/material.dart';
import 'package:live_vitalist/core/theme/custom_icons.dart';

class AppLogo extends StatelessWidget {
  final double size;
  const AppLogo({super.key, this.size = 128.0});

  static const heroTag = 'app-logo';

  static const List<Color> _logoGradientColors = [
    Color(0xFF119033),
    Color(0xFF64B724),
    Color(0xFF98D02F),
  ];

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        stops: [0.25, 0.5, 0.75],
        colors: _logoGradientColors,
      ).createShader(bounds),
      child: Icon(
        CustomIcons.logo,
        size: size,
        color: Colors.white,
        shadows: [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.5),
            blurRadius: 8.0,
            offset: Offset(0.0, 2.0),
          ),
        ],
      ),
    );
  }
}
