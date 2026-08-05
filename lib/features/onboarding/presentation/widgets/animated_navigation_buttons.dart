import 'package:flutter/material.dart';

class AnimatedNavigationButtons extends StatelessWidget {
  final bool showBackButton;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const AnimatedNavigationButtons({
    super.key,
    required this.showBackButton,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(
            begin: 0.0,
            end: showBackButton ? 1.0 : 0.0,
          ),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          builder: (context, t, child) => Align(
            alignment: Alignment.centerLeft,
            widthFactor: t,
            child: Transform.scale(
              alignment: Alignment.centerLeft,
              scale: t,
              child: child,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton.filledTonal(
                onPressed: onPrevious,
                icon: const Icon(Icons.arrow_back_rounded),
              ),
              const SizedBox(width: 16.0),
            ],
          ),
        ),
        Expanded(
          child: FilledButton(
            onPressed: onNext,
            child: Text('Continue'),
          ),
        ),
      ],
    );
  }
}
