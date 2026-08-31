import 'package:flutter/material.dart';

class LocalizedRichText extends StatelessWidget {
  final String text;
  final Map<String, InlineSpan> replacements;
  final TextStyle? style;
  final TextAlign textAlign;

  const LocalizedRichText({
    super.key,
    required this.text,
    required this.replacements,
    this.style,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: style,
        children: _buildSpans(),
      ),
      textAlign: textAlign,
    );
  }

  List<InlineSpan> _buildSpans() {
    final spans = <InlineSpan>[];
    var remainingText = text;

    while (remainingText.isNotEmpty) {
      String? nextToken;
      var nextTokenIndex = remainingText.length;

      for (final token in replacements.keys) {
        final tokenIndex = remainingText.indexOf(token);
        if (tokenIndex >= 0 && tokenIndex < nextTokenIndex) {
          nextToken = token;
          nextTokenIndex = tokenIndex;
        }
      }

      if (nextToken == null) {
        spans.add(TextSpan(text: remainingText));
        break;
      }

      if (nextTokenIndex > 0) {
        spans.add(TextSpan(text: remainingText.substring(0, nextTokenIndex)));
      }

      spans.add(replacements[nextToken]!);
      remainingText = remainingText.substring(
        nextTokenIndex + nextToken.length,
      );
    }

    return spans;
  }
}
