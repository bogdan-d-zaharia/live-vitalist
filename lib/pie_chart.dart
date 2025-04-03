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

  @override
  Widget build(BuildContext context) {
    const int numDigits = 0;
    // final Color red = Color.lerp(Colors.red, Colors.grey, 0.1)!;
    // final Color blue = Color.lerp(Colors.blue, Colors.grey, 0.1)!;
    // final Color yellow = Color.lerp(Colors.yellow, Colors.grey, 0.1)!;

    return CustomCard(
      logo: Icon(Icons.pie_chart),
      title: 'Macro distribution (% calories)',
      child: Row(
        children: [
          MacroLabelsWidget(),
          Column(
            children: [
              SizedBox(
                width: 100.0,
                height: 100.0,
                child: flc.PieChart(
                  flc.PieChartData(
                    startDegreeOffset: -90.0,
                    sections: [
                      flc.PieChartSectionData(
                        color: Palette.proteinRed,
                        value: targetDistribution['Protein'],
                        title:
                            '${(targetDistribution['Protein']! * 100.0).toStringAsFixed(numDigits)}%',
                      ),
                      flc.PieChartSectionData(
                        color: Palette.fatYellow,
                        value: targetDistribution['Fats'],
                        title:
                            '${(targetDistribution['Fats']! * 100.0).toStringAsFixed(numDigits)}%',
                      ),
                      flc.PieChartSectionData(
                        color: Palette.carbBlue,
                        value: targetDistribution['Carbs'],
                        title:
                            '${(targetDistribution['Carbs']! * 100.0).toStringAsFixed(numDigits)}%',
                      ),
                    ],
                  ),
                ),
              ),
              Text('Objective'),
            ],
          ),
          Spacer(),
          Column(
            children: [
              SizedBox(
                width: 100.0,
                height: 100.0,
                child: flc.PieChart(
                  flc.PieChartData(
                    startDegreeOffset: -90.0,
                    sections: [
                      flc.PieChartSectionData(
                        color: Palette.proteinRed,
                        value: distribution['Protein'],
                        title:
                            '${(distribution['Protein']! * 100.0).toStringAsFixed(numDigits)}%',
                      ),
                      flc.PieChartSectionData(
                        color: Palette.fatYellow,
                        value: distribution['Fats'],
                        title:
                            '${(distribution['Fats']! * 100.0).toStringAsFixed(numDigits)}%',
                      ),
                      flc.PieChartSectionData(
                        color: Palette.carbBlue,
                        value: distribution['Carbs'],
                        title:
                            '${(distribution['Carbs']! * 100.0).toStringAsFixed(numDigits)}%',
                      ),
                    ],
                  ),
                ),
              ),
              Text('Distribution'),
            ],
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
        child: Column(
          children: elements,
        ),
      );
    } else {
      for (int i = elements.length - 1; i > 0; i--) {
        elements.insert(i, Spacer());
      }
      return Row(children: elements);
    }
  }
}
