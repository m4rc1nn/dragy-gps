import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../models/speed_measurement.dart';

class ChartScreen extends StatelessWidget {
  final SpeedMeasurement speedMeasurement;
  ChartScreen({required Key key, required this.speedMeasurement})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('Wykres'),
          centerTitle: true,
        ),
        body: Container(
          color: Colors.grey[800],
          child: ListView(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            children: <Widget>[
              ChartContainer(
                title: 'Przebieg przyśpieszenia',
                color: Color.fromRGBO(45, 108, 223, 1),
                chart: LineChartContent(
                    key: UniqueKey(), speedMeasurement: speedMeasurement),
              ),
            ],
          ),
        ));
  }
}

class ChartContainer extends StatelessWidget {
  final Color color;
  final String title;
  final Widget chart;

  const ChartContainer({
    Key? key,
    required this.title,
    required this.color,
    required this.chart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.width * 0.80,
        padding: EdgeInsets.fromLTRB(0, 10, 20, 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            Expanded(
                child: Container(
              padding: EdgeInsets.only(top: 10),
              child: chart,
            ))
          ],
        ),
      ),
    );
  }
}

class LineChartContent extends StatelessWidget {
  final SpeedMeasurement speedMeasurement;

  LineChartContent({required Key key, required this.speedMeasurement})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint(speedMeasurement.accelerationList.last.toString());
    debugPrint(speedMeasurement.accelerationList.length.toString());
    return LineChart(
      LineChartData(
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(),
            topTitles: AxisTitles(),
          ),
          minY: speedMeasurement.getStart().toDouble(),
          maxY: speedMeasurement.getEnd().toDouble(),
          lineBarsData: [
            LineChartBarData(
                color: Colors.black,
                isStepLineChart: true,
                isCurved: true,
                spots: speedMeasurement.accelerationList
                    .asMap()
                    .entries
                    .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
                    .toList())
          ]),
    );
  }
}
