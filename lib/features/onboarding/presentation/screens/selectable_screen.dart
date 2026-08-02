import 'package:flutter/material.dart';
import 'package:live_vitalist/features/onboarding/domain/options/option_interface.dart';
import 'package:live_vitalist/features/onboarding/presentation/widgets/option_card.dart';

class SelectableScreen<T extends IOption> extends StatelessWidget {
  final String question;
  final Map<T, Widget> options;
  final T selected;
  final ValueChanged<T> select;

  const SelectableScreen({
    super.key,
    required this.question,
    required this.options,
    required this.selected,
    required this.select,
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
            ...options.entries.map(
              (entry) {
                final MapEntry(key: option, value: child) = entry;
                return OptionCard(
                  isSelected: option == selected,
                  onTap: () => select(option),
                  child: child,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
