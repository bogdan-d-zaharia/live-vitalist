import 'package:flutter/material.dart';
import 'package:live_vitalist/core/presentation/widgets/mini_card.dart';

class NewSynonymInput extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController valueController;
  final Function() onAdd;

  const NewSynonymInput({
    required this.nameController,
    required this.valueController,
    required this.onAdd,
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
                decoration: const InputDecoration(hintText: 'New unit name'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 1,
              child: TextField(
                controller: valueController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Value'),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: onAdd,
            )
          ],
        ),
      ),
    );
  }
}
