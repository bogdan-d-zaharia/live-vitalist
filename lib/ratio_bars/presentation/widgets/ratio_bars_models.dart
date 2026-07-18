import 'dart:ui';

import 'package:flutter/foundation.dart';

@immutable
class RatioBarElement {
  const RatioBarElement(
    this.label,
    this.amount,
    this.color,
  );

  final String label;
  final double amount;
  final Color color;
}

@immutable
class RatioBar {
  const RatioBar(
    this.text,
    this.elements,
  );

  final String text;
  final List<RatioBarElement> elements;
}
