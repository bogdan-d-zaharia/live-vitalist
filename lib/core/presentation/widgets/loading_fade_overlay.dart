import 'package:flutter/material.dart';

class LoadingFadeOverlay extends StatefulWidget {
  const LoadingFadeOverlay({super.key});

  @override
  State<LoadingFadeOverlay> createState() => _LoadingFadeOverlayState();
}

class _LoadingFadeOverlayState extends State<LoadingFadeOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
      value: 0.5,
    )..repeat();

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final position = -3.0 + (_animation.value * 6.0);

        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(position - 2.0, position - 2.0),
              end: Alignment(position, position),
              colors: [
                Colors.black.withValues(alpha: 0.25),
                Colors.black.withValues(alpha: 0.05),
                Colors.black.withValues(alpha: 0.0),
                Colors.black.withValues(alpha: 0.05),
                Colors.black.withValues(alpha: 0.25),
              ],
              stops: [0.0, 0.4, 0.5, 0.6, 1.0],
            ),
          ),
          child: SizedBox.expand(),
        );
      },
    );
  }
}
