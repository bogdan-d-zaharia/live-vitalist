import 'package:flutter/material.dart';
import 'package:live_vitalist/core/presentation/widgets/custom_card.dart';
import 'package:live_vitalist/core/presentation/widgets/labels_widget.dart';
import 'package:live_vitalist/ratio_bars/presentation/widgets/bar.dart';
import 'package:live_vitalist/ratio_bars/presentation/widgets/ratio_bars_models.dart';

class RatioBars extends StatelessWidget {
  const RatioBars({
    required this.bars,
    super.key,
  });

  final List<RatioBar> bars;

  @override
  Widget build(BuildContext context) {
    final children = bars
        .expand((bar) => [
              Text(bar.text),
              SizedBox(height: 4.0),
              Bar(elements: bar.elements),
              SizedBox(height: 4.0),
              LabelsWidget(
                map: Map.fromEntries(
                    bar.elements.map((e) => MapEntry(e.label, e.color))),
                isHorizontal: true,
              ),
              SizedBox(height: 20.0)
            ])
        .toList()
      ..removeLast();

    return CustomCard(
      logo: Icon(Icons.stacked_bar_chart_rounded),
      title: 'Distribution Bars',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
