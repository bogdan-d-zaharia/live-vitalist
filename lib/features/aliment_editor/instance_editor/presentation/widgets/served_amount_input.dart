import 'package:flutter/material.dart';
import 'package:live_vitalist/core/presentation/widgets/data_input/number_input.dart';

class ServedAmountInput extends StatelessWidget {
  final double Function() getValue;
  final void Function(double) setValue;

  const ServedAmountInput({
    required this.getValue,
    required this.setValue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Served amount:', style: Theme.of(context).textTheme.bodyLarge),
        Expanded(
          child: Center(
            child: NumberInput(
              getValue: getValue,
              setValue: setValue,
            ),
          ),
        ),
      ],
    );
  }
}
