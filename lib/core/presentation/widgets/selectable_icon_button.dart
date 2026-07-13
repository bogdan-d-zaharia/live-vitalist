import 'package:flutter/material.dart';

class SelectableIconButton extends StatelessWidget {
  final bool isSelected;
  final void Function()? onPressed;
  final Widget icon;
  final Color selectedColor;
  final double buttonSize;
  final double iconSize;

  const SelectableIconButton({
    super.key,
    required this.isSelected,
    this.onPressed,
    required this.icon,
    required this.selectedColor,
    required this.buttonSize,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: icon,
      iconSize: iconSize,
      constraints: BoxConstraints(
        minHeight: buttonSize,
        minWidth: buttonSize,
      ),
      style: IconButton.styleFrom(
        backgroundColor: isSelected ? selectedColor : null,
        foregroundColor: isSelected ? Colors.white : null,
      ),
    );
  }
}
