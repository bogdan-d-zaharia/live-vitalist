import 'package:flutter/material.dart';
import 'package:live_vitalist/core/theme/palette.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Palette.divGrey,
      thickness: 0.5,
      height: 0.0,
    );
  }
}
