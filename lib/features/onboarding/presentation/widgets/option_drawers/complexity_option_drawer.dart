import 'package:flutter/material.dart' hide SelectableText;
import 'package:live_vitalist/features/onboarding/domain/options/complexity_option.dart';
import 'package:live_vitalist/features/onboarding/presentation/widgets/selectable_text.dart';

class ComplexityOptionDrawer extends StatelessWidget {
  final ComplexityOption complexity;
  final bool isSelected;
  const ComplexityOptionDrawer({
    super.key,
    required this.complexity,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final string = switch (complexity) {
      ComplexityOption.easiest => "Calories only",
      ComplexityOption.normal => "Calories and macros",
      ComplexityOption.advance => "Advance",
      ComplexityOption.extreme => "Extreme",
    };
    final text = SelectableText(string, isSelected: isSelected);
    final count = switch (complexity) {
      ComplexityOption.easiest => 1,
      ComplexityOption.normal => 2,
      ComplexityOption.advance => 3,
      ComplexityOption.extreme => 4,
    };
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        text,
        // Column(
        //   spacing: 5.0,
        //   children: List.generate(
        //     count,
        //     (_) => Container(
        //       decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(128.0),
        //         color: Colors.grey,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
