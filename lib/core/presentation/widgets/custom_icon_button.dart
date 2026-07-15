import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    required this.onTap,
    required this.icon,
    super.key,
  });

  final void Function() onTap;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1.0,
      borderRadius: BorderRadius.circular(8.0),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 26.0,
          height: 26.0,
          child: icon,
        ),
      ),
    );
  }
}
