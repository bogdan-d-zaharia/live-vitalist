import 'package:flutter/material.dart';

class SizedIconButton extends StatelessWidget {
  final void Function()? onPressed;
  final Widget icon;
  final double buttonSize;
  final double iconSize;

  const SizedIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
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
        minWidth: buttonSize,
        minHeight: buttonSize,
      ),
    );
  }
}
