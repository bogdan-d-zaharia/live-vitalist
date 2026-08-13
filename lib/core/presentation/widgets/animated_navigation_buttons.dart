import 'package:flutter/material.dart';

class AnimatedNavigationButtons extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback? onPrevious;
  final VoidCallback? onSkip;
  final String nextLabel;

  const AnimatedNavigationButtons({
    super.key,
    required this.onNext,
    this.onPrevious,
    this.onSkip,
    this.nextLabel = 'Continue',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(
            begin: 0.0,
            end: onPrevious != null ? 1.0 : 0.0,
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
            child: Text(nextLabel),
          ),
        ),
        TweenAnimationBuilder<double>(
          tween: Tween(
            begin: 0.0,
            end: onSkip != null ? 1.0 : 0.0,
          ),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          builder: (context, t, child) => Align(
            alignment: Alignment.centerRight,
            widthFactor: t,
            child: Transform.scale(
              alignment: Alignment.centerRight,
              scale: t,
              child: child,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 16.0),
              IconButton.filledTonal(
                onPressed: onSkip,
                icon: const Icon(Icons.fast_forward_rounded),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
