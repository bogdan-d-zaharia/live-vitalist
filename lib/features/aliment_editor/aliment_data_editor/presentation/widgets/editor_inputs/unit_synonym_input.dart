import 'package:flutter/material.dart';
import 'package:live_vitalist/core/presentation/widgets/mini_card.dart';

class UnitSynonymInput extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController valueController;
  final Function(String newKey) onRename;
  final Function(double value) onValueChanged;
  final Function() onDelete;

  const UnitSynonymInput({
    required this.nameController,
    required this.valueController,
    required this.onRename,
    required this.onValueChanged,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MiniCard(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(hintText: 'Name'),
                onSubmitted: onRename,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 1,
              child: TextField(
                controller: valueController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Value'),
                onSubmitted: (val) {
                  final parsed = double.tryParse(val.trim());
                  if (parsed == null || parsed <= 0) return;
                  onValueChanged(parsed);
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
