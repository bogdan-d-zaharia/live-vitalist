import 'package:flutter/material.dart';

class CompletionWidget extends StatelessWidget {
  final int count;
  final int index;
  final int bulletFlex;
  final int selectedFlex;
  final Color? uncompletedColor;
  final Color? completedColor;

  const CompletionWidget({
    super.key,
    required this.count,
    required this.index,
    this.bulletFlex = 3,
    this.selectedFlex = 5,
    this.uncompletedColor,
    this.completedColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final uncompleted = uncompletedColor ?? colors.surfaceContainerHighest;
    final completed = completedColor ?? colors.primary;

    return Row(
      children: List.generate(2 * count - 1, (idx) {
        final i = idx / 2;

        if (idx % 2 == 0) {
          return Flexible(
            flex: i == index ? selectedFlex : bulletFlex,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                color: i <= index ? completed : uncompleted,
              ),
            ),
          );
        }
        return Spacer();
      }),
    );
  }
}
