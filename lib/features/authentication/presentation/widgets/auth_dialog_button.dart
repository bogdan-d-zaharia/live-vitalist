import 'package:flutter/material.dart';

class AuthDialogButton extends StatelessWidget {
  final Function() onPressed;
  final Widget label;
  final Color backgroundColor;

  const AuthDialogButton({
    super.key,
    required this.onPressed,
    required this.label,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120.0,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        label: label,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}
