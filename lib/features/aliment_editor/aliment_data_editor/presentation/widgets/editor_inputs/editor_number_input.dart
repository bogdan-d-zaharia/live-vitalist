import 'package:flutter/material.dart';
import 'package:live_vitalist/core/presentation/widgets/data_input/number_input.dart';
import 'package:live_vitalist/core/presentation/widgets/mini_card.dart';

class EditorNumberInput extends StatelessWidget {
  final String label;
  final double Function() getValue;
  final void Function(double) setValue;
  final String? unit;

  const EditorNumberInput(
    this.label,
    this.getValue,
    this.setValue, {
    this.unit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MiniCard(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(child: Text('$label:', overflow: TextOverflow.ellipsis)),
            const SizedBox(width: 12),
            NumberInput(
              getValue: getValue,
              setValue: setValue,
              showHandles: false,
            ),
            if (unit != null) ...[
              const SizedBox(width: 12),
              Text(unit!),
            ],
          ],
        ),
      ),
    );
  }
}
