import 'package:flutter/material.dart';
import 'package:live_vitalist/palette.dart';
import 'package:live_vitalist/ratio_bars/presentation/widgets/ratio_bars_models.dart';

class Bar extends StatelessWidget {
  const Bar({
    super.key,
    required this.elements,
    this.height = 12.0,
    this.radius = 7.0,
    this.fontSize = 11.0,
  });

  final List<RatioBarElement> elements;
  final double height;
  final double radius;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final double total =
        elements.map((e) => e.amount).fold(0.0, (a, b) => a + b);
    if (total == 0.0) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: Colors.grey,
        ),
        height: height,
      );
    } else {
      return Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(radius)),
        clipBehavior: Clip.antiAlias,
        height: height,
        child: Row(
          children: elements.map(
            (e) {
              final s = '${(e.amount * 100.0 / total).toStringAsFixed(0)}%';
              return Expanded(
                flex: (e.amount * 1e3).round(),
                child: Container(
                  color: e.color,
                  child: switch (s != '0%') {
                    true => Center(
                        child: Text(
                          s,
                          style: Palette.dayViewRegular.copyWith(
                            fontSize: fontSize,
                            color: Colors.black.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                    false => null,
                  },
                ),
              );
            },
          ).toList(),
        ),
      );
    }
  }
}
