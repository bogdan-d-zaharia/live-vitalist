import 'package:flutter/material.dart';

class SelectableText extends StatelessWidget {
  final String text;
  final bool isSelected;
  const SelectableText(this.text, {super.key, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textStyle = theme.textTheme.titleMedium
        ?.copyWith(color: isSelected ? colors.onPrimaryContainer : null);
    return Text(text, textAlign: TextAlign.center, style: textStyle);
  }
}
