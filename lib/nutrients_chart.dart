import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'cache_handler.dart';
import 'custom_card.dart';
import 'day.dart';
import 'models/reference_fields_model.dart';

class NutrientsChart extends StatelessWidget {
  const NutrientsChart({super.key});

  Future<LineChartData> fetchData() async {
    final DateTime tNow = DateTime.now();
    final DateTime date = DateTime(tNow.year, tNow.month, tNow.day);

    // Constructing a map of nutrients and values over the week.
    final Map<String, List<double>> map = {};

    for (int i = 0; i < 7; ++i) {
      final Day day = await DayHandler.getDay(
        date.subtract(Duration(days: i)),
      );

      for (final pair in day.intake.entries) {
        final double? l = NutrientsHandler.model[pair.key]!['lowerLimit'];
        final double? u = NutrientsHandler.model[pair.key]!['upperLimit'];
        if (l == null && u != null) {
          if (map[pair.key] == null) {
            map[pair.key] = [for (int j = 0; j < i; ++j) 0.0];
          }
          map[pair.key]!.add(pair.value / u * 100.0);
        }
      }
    }

    // Converting it to line chart data.
    final List<LineChartBarData> lineChartBars = [];
    for (var pair in map.entries) {
      final List<FlSpot> spots = [];
      for (int i = 0; i < pair.value.length; ++i) {
        spots.add(FlSpot(-i.toDouble(), pair.value[i]));
      }
      lineChartBars.add(LineChartBarData(spots: spots));
    }
    final LineChartData lineChartData = LineChartData(
      lineBarsData: lineChartBars,
      minY: 0.0,
      maxY: 150.0,
      borderData: FlBorderData(border: Border.all(color: Colors.amber)),
      clipData: FlClipData.all(),
      backgroundColor: Colors.transparent,
    );

    return lineChartData;
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      logo: Icon(Icons.trending_up_rounded),
      title: 'Nutrients Chart',
      child: SizedBox(
          width: 300.0,
          height: 200.0,
          child: FutureBuilder(
            future: fetchData(),
            builder: (context, snapshot) {
              if (snapshot.hasData && (snapshot.data != null)) {
                return LineChart(
                  snapshot.data!,
                );
              } else if (snapshot.hasError) {
                // TODO: Replace with a reload button, perhaps.
                throw Exception(
                    snapshot.hasError ? snapshot.error.toString() : '');
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          )),
    );
  }
}
