import 'package:flutter/material.dart';
import 'package:live_vitalist/core/theme/palette.dart';
import 'package:live_vitalist/features/nutrient_display/presentation/nutrients_display_constants.dart';

class AddonText extends StatelessWidget {
  final String text;
  final Color? emphasisColor;
  const AddonText({super.key, required this.text, this.emphasisColor});

  @override
  Widget build(BuildContext context) {
    final textW = Text(
      text,
      style: Palette.dayViewRegular.copyWith(
        fontSize: fontSize,
        color: Colors.black.withValues(alpha: 0.6),
      ),
    );
    if (emphasisColor == null) return textW;

    return Container(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(blurRadius: 4.0, color: emphasisColor!)],
      ),
      child: textW,
    );
  }
}
