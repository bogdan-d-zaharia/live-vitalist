import 'package:flutter/material.dart';
import 'palette.dart';

class CloseButton extends StatelessWidget {
  const CloseButton({super.key, required this.onTap, this.size = 20.0});

  final void Function()? onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(size / 2.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size / 2.0),
          border: Border.all(
            color: Palette.almostWhite,
            width: 1.0 / 20.0 * size,
          ),
        ),
        width: size,
        height: size,
        child: Center(
          child: Icon(
            Icons.close_rounded,
            size: size * 0.7,
            color: Palette.almostWhite,
          ),
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    this.logo,
    this.title,
    this.highlightText,
    this.onHighlightTap,
    this.isClosable = false,
    this.headerSpace = 12.0,
    this.action,
    this.onTap,
    this.onLongTap,
    this.child,
  });

  final Widget? logo;
  final String? title;
  final String? highlightText;
  final void Function()? onHighlightTap;
  final Widget? action;

  /// Adds a `CloseButton` when enabled.
  final bool isClosable;

  /// Adds space between the header and the child using a `SizedBox`.
  ///
  /// It does not add the `SizedBox` when 0.0.
  final double headerSpace;
  final void Function()? onTap;
  final void Function()? onLongTap;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final Widget interior = Padding(
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
              if (isClosable) CloseButton(onTap: () {}),
              if (!isClosable && highlightText != null)
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
    );

    final bool useInkWell = onTap != null || onLongTap != null;

    return MiniCard(
      child: !useInkWell
          ? interior
          : InkWell(
              onTap: onTap,
              onLongPress: onLongTap,
              child: interior,
            ),
    );
  }
}

class MiniCard extends StatelessWidget {
  const MiniCard({
    this.child,
    super.key,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: child,
    );
  }
}
