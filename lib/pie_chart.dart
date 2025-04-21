import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart' as flc;

import 'custom_card.dart';
import 'palette.dart';

class PieChart extends StatelessWidget {
  const PieChart({
    required this.distribution,
    required this.targetDistribution,
    super.key,
  });

  final Map<String, double> distribution;
  final Map<String, double> targetDistribution;

  Widget pie(Map<String, double> distribution) {
    const int numDigits = 0;

    return AspectRatio(
      aspectRatio: 1.0,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.biggest.shortestSide;
          final radius = size / 2;
          final centerSpace = radius * 0.20;
          final sliceRadius = radius - centerSpace;

          return flc.PieChart(
            flc.PieChartData(
              centerSpaceRadius: centerSpace,
              startDegreeOffset: -90.0,
              sections: [
                flc.PieChartSectionData(
                  radius: sliceRadius,
                  color: Palette.proteinRed,
                  value: distribution['Protein'],
                  title:
                      '${(distribution['Protein']! * 100.0).toStringAsFixed(numDigits)}%',
                ),
                flc.PieChartSectionData(
                  radius: sliceRadius,
                  color: Palette.fatYellow,
                  value: distribution['Fats'],
                  title:
                      '${(distribution['Fats']! * 100.0).toStringAsFixed(numDigits)}%',
                ),
                flc.PieChartSectionData(
                  radius: sliceRadius,
                  color: Palette.carbBlue,
                  value: distribution['Carbs'],
                  title:
                      '${(distribution['Carbs']! * 100.0).toStringAsFixed(numDigits)}%',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      logo: Icon(Icons.pie_chart),
      title: 'Macro distribution (% calories)',
      child: Row(
        children: [
          MacroLabelsWidget(),
          Expanded(
            child: Column(
              children: [
                pie(targetDistribution),
                Text('Objective'),
              ],
            ),
          ),
          SizedBox(width: 18.0),
          Expanded(
            child: Column(
              children: [
                pie(distribution),
                Text('Distribution'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MacroLabelsWidget extends StatelessWidget {
  const MacroLabelsWidget({
    this.horizontal = false,
    this.order = const [0, 1, 2],
    this.values,
    super.key,
  });

  final bool horizontal;
  final List<int> order;
  final List<double>? values;

  @override
  Widget build(BuildContext context) {
    final List<Widget> elements = ({0: 'Protein', 1: 'Carbs', 2: 'Fats'}
            /* Add the values if needed */
            .map((idx, val) => MapEntry(idx,
                '$val${values?[idx] != null ? ': ${values![idx].toStringAsFixed(2)}g' : ''}'))
            /* Map to widgets */
            .map((idx, val) => MapEntry(
                  idx,
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: [
                            Palette.proteinRed,
                            Palette.carbBlue,
                            Palette.fatYellow
                          ][idx],
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                        width: 10.0,
                        height: 10.0,
                        margin: EdgeInsets.only(right: 5.0),
                      ),
                      Text(val),
                    ],
                  ),
                ))
            /* Sort and finish */
            .entries
            .toList()
          ..sort((a, b) => order[a.key].compareTo(order[b.key])))
        .map((e) => e.value)
        .toList();

    if (!horizontal) {
      return SizedBox(
        width: 100.0,
        height: 100.0,
        child: Column(children: elements),
      );
    } else {
      for (int i = elements.length - 1; i > 0; i--) {
        elements.insert(i, Spacer());
      }
      return Row(children: elements);
    }
  }
}
