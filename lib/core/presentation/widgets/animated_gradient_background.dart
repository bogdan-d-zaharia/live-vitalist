import 'dart:math';

import 'package:flutter/material.dart';
import 'package:live_vitalist/core/theme/app_background_theme.dart';

class AnimatedGradientBackground extends StatefulWidget {
  const AnimatedGradientBackground({super.key, this.child});

  final Widget? child;

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  Duration get duration => AppBackgroundTheme.of(context).cycleDuration;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppBackgroundTheme.light.cycleDuration,
    )..repeat();
  }

  // Duration might change from light mode to dark mode.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.duration = duration;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppBackgroundTheme.of(context);

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => CustomPaint(
          painter: _MeshGradientPainter(
            colors: theme.colors,
            t: _controller.value,
          ),
          child: child,
        ),
        child: widget.child,
      ),
    );
  }
}

class _MeshGradientPainter extends CustomPainter {
  _MeshGradientPainter({
    required this.colors,
    required this.t,
  });

  final List<Color> colors;
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.longestSide * 0.65;

    for (var i = 0; i < colors.length; i++) {
      final phaseOffset = i * (2 * pi / colors.length);
      final angleX = 2 * pi * t + phaseOffset;
      // final angleY = 2 * pi * t * 1.3 + phaseOffset * 1.7;

      final center = Offset(
        size.width * (0.5 + 0.35 * cos(angleX)),
        size.height * (0.5 + 0.35 * sin(angleX)),
      );

      final blobPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            colors[i],
            colors[i].withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: radius));

      canvas.drawCircle(center, radius, blobPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _MeshGradientPainter oldDelegate) {
    return oldDelegate.t != t || oldDelegate.colors != colors;
  }
}
