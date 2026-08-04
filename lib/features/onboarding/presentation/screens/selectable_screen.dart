import 'package:flutter/material.dart';

class SelectableScreen extends StatelessWidget {
  final String question;
  final List<Widget> options;

  const SelectableScreen({
    super.key,
    required this.question,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 20.0,
          children: [
            Text(
              question,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            ...options,
          ],
        ),
      ),
    );
  }
}
