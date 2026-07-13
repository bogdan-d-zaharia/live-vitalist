import 'package:flutter/material.dart';

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
