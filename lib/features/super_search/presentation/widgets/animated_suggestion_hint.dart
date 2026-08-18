import 'package:flutter/material.dart';
import 'package:live_vitalist/features/super_search/presentation/utils/fade_in_out_curve.dart';

class AnimatedSuggestionHint extends StatefulWidget {
  final int animationKey;
  final String? text;
  final Duration duration;
  final TextEditingController? controller;
  final EdgeInsets padding;

  const AnimatedSuggestionHint({
    super.key,
    required this.animationKey,
    required this.text,
    required this.duration,
    required this.controller,
    required this.padding,
  });

  @override
  State<AnimatedSuggestionHint> createState() => _AnimatedSuggestionHintState();
}

class _AnimatedSuggestionHintState extends State<AnimatedSuggestionHint>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _opacityAnimation = CurvedAnimation(
      parent: _animationController,
      curve: FadeInOutCurve(),
    );
    _animationController.forward();
  }

  @override
  void didUpdateWidget(covariant AnimatedSuggestionHint oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.animationKey != widget.animationKey) {
      _animationController.duration = widget.duration;
      _animationController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget buildHint(bool isVisible) {
      return AnimatedBuilder(
        animation: _opacityAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: isVisible ? _opacityAnimation.value * 0.6 : 0.0,
            child: child,
          );
        },
        child: Text(
          widget.text ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return IgnorePointer(
      child: Padding(
        padding: widget.padding,
        child: Align(
          alignment: Alignment.centerLeft,
          child: widget.controller == null
              ? buildHint(true)
              : ValueListenableBuilder<TextEditingValue>(
                  valueListenable: widget.controller!,
                  builder: (context, value, child) {
                    return buildHint(value.text.isEmpty);
                  },
                ),
        ),
      ),
    );
  }
}
