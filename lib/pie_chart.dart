import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart' as flc;

import 'custom_card.dart';

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
    final Color red = Color.lerp(Colors.red, Colors.grey, 0.1)!;
    final Color blue = Color.lerp(Colors.blue, Colors.grey, 0.1)!;
    final Color yellow = Color.lerp(Colors.yellow, Colors.grey, 0.1)!;

    return CustomCard(
      logo: Icon(Icons.pie_chart),
      title: 'Macro distribution (% calories)',
      child: Row(
        children: [
          SizedBox(
            width: 100.0,
            height: 100.0,
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: red,
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                      width: 10.0,
                      height: 10.0,
                      margin: EdgeInsets.only(right: 5.0),
                    ),
                    Text('Protein'),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: blue,
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                      width: 10.0,
                      height: 10.0,
                      margin: EdgeInsets.only(right: 5.0),
                    ),
                    Text('Carbs'),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: yellow,
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                      width: 10.0,
                      height: 10.0,
                      margin: EdgeInsets.only(right: 5.0),
                    ),
                    Text('Fats'),
                  ],
                ),
              ],
            ),
          ),
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
                        color: red,
                        value: targetDistribution['Protein'],
                        title:
                            '${(targetDistribution['Protein']! * 100.0).toStringAsFixed(numDigits)}%',
                      ),
                      flc.PieChartSectionData(
                        color: yellow,
                        value: targetDistribution['Fats'],
                        title:
                            '${(targetDistribution['Fats']! * 100.0).toStringAsFixed(numDigits)}%',
                      ),
                      flc.PieChartSectionData(
                        color: blue,
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
                        color: red,
                        value: distribution['Protein'],
                        title:
                            '${(distribution['Protein']! * 100.0).toStringAsFixed(numDigits)}%',
                      ),
                      flc.PieChartSectionData(
                        color: yellow,
                        value: distribution['Fats'],
                        title:
                            '${(distribution['Fats']! * 100.0).toStringAsFixed(numDigits)}%',
                      ),
                      flc.PieChartSectionData(
                        color: blue,
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
