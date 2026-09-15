import 'package:flutter/material.dart';

class TonalIcon extends StatelessWidget {
  final Icon icon;
  const TonalIcon({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 48.0,
      height: 48.0,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: IconTheme(
          data: IconThemeData(
            color: colorScheme.onSecondaryContainer,
          ),
          child: icon,
        ),
      ),
    );
  }
}
