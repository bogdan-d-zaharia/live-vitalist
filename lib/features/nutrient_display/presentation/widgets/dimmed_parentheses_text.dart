import 'package:flutter/material.dart';

class DimmedParenthesesText extends StatelessWidget {
  const DimmedParenthesesText({required this.label, this.style, super.key});

  final String label;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = style ?? const TextStyle();

    var x = label.indexOf('(');
    x = x != -1 ? x : label.length;

    final label1 = label.substring(0, x);
    final label2 = label.substring(x);

    return RichText(
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      text: TextSpan(
        children: [
          TextSpan(text: label1, style: effectiveStyle),
          TextSpan(
            text: label2,
            style: effectiveStyle.copyWith(
              color: Colors.grey,
              fontSize: effectiveStyle.fontSize != null
                  ? effectiveStyle.fontSize! - 2.5
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
