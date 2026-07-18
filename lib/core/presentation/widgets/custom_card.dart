import 'package:flutter/material.dart';
import 'package:live_vitalist/core/presentation/widgets/mini_card.dart';
import 'package:live_vitalist/core/theme/palette.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    this.logo,
    this.title,
    this.highlightText,
    this.onHighlightTap,
    this.headerSpace = 12.0,
    this.action,
    this.child,
  });

  final Widget? logo;
  final String? title;
  final String? highlightText;
  final void Function()? onHighlightTap;
  final Widget? action;

  /// Adds space between the header and the child using a `SizedBox`.
  ///
  /// It does not add the `SizedBox` when 0.0.
  final double headerSpace;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return MiniCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 25.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (logo != null) logo!,
                if (logo != null) const SizedBox(width: 8.0),
                if (title != null)
                  Text(
                    title!,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                const Spacer(),
                if (highlightText != null)
                  InkWell(
                    onTap: onHighlightTap,
                    child: Text(
                      highlightText!,
                      style: Palette.highlight,
                    ),
                  ),
                if (action != null) action!,
              ],
            ),
            if (headerSpace != 0.0) SizedBox(height: headerSpace),
            if (child != null) child!,
          ],
        ),
      ),
    );
  }
}
