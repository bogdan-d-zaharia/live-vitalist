import 'package:flutter/material.dart';
import 'package:live_vitalist/core/presentation/widgets/mini_card.dart';

class EditorStringInput extends StatelessWidget {
  final String label;
  final String value;
  final void Function(String) onChanged;
  final TextEditingController controller;

  const EditorStringInput(
    this.label,
    this.value,
    this.onChanged,
    this.controller, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MiniCard(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Text('$label:'),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                style: Theme.of(context).textTheme.bodyMedium,
                controller: controller,
                onChanged: onChanged,
              ),
            )
          ],
        ),
      ),
    );
  }
}
