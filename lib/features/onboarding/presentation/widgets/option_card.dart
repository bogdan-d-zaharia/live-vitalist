import 'package:flutter/material.dart';

class OptionCard extends StatelessWidget {
  final Widget child;
  final bool isSelected;
  final VoidCallback onTap;

  const OptionCard({
    super.key,
    required this.child,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final radius = BorderRadius.circular(16.0);

    return AnimatedContainer(
      duration: Duration(milliseconds: 128),
      decoration: BoxDecoration(
        borderRadius: radius,
        border: Border.all(
          color: isSelected ? colors.primary : colors.outlineVariant,
          width: isSelected ? 3.0 : 1.0,
        ),
        color: isSelected ? colors.primaryContainer : null,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: SizedBox(
          width: double.infinity,
          height: 100.0,
          child: Center(child: child),
        ),
      ),
    );
  }
}
