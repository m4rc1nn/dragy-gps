import 'package:dragy_gps/screens/chart_screen.dart';
import 'package:flutter/material.dart';
import '../models/speed_measurement.dart';

class DistanceCard extends StatelessWidget {
  final SpeedMeasurement speedMeasurement;
  final Function remove;
  final int id;
  const DistanceCard(
      {required Key key,
      required int this.id,
      required SpeedMeasurement this.speedMeasurement,
      required this.remove})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
      child: ClipPath(
        child: Container(
          padding: EdgeInsets.all(0),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: speedMeasurement.getColor(), width: 5),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                  leading: Icon(Icons.speed, size: 48),
                  title: Text(
                      speedMeasurement.start.toString() +
                          ' - ' +
                          speedMeasurement.end.toString(),
                      style: TextStyle(fontSize: 25)),
                  subtitle: speedMeasurement.getStatus() ==
                              StatusType.FINISHED ||
                          speedMeasurement.getStatus() == StatusType.IN_PROGRESS
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(Icons.timer_outlined),
                                  Text(' Czas: '),
                                  Text((speedMeasurement
                                                  .getEndTime()
                                                  .difference(speedMeasurement
                                                      .getStartTime())
                                                  .inMilliseconds /
                                              1000)
                                          .toStringAsFixed(2) +
                                      'sek'),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(Icons.timer_outlined),
                                  Text(' Dystans: '),
                                  Text(speedMeasurement
                                          .getDistanceTraveled()
                                          .toStringAsFixed(2) +
                                      'm'),
                                ],
                              )
                            ])
                      : Text('Oczekuje na rozpoczęcie pomiaru...')),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    child: Row(
                        children: <Widget>[Icon(Icons.delete), Text('USUŃ')]),
                    onPressed: () {
                      remove(speedMeasurement);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.grey[900],
                          content: Text(
                              'Usunięto pomiar ' +
                                  speedMeasurement.getStart().toString() +
                                  ' - ' +
                                  speedMeasurement.getEnd().toString(),
                              style: TextStyle(color: Colors.white)),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    child: Row(children: <Widget>[
                      Icon(Icons.show_chart),
                      Text('WYKRES')
                    ]),
                    onPressed: () {
                      speedMeasurement.getStatus() == StatusType.FINISHED
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChartScreen(
                                      key: UniqueKey(),
                                      speedMeasurement: speedMeasurement)),
                            )
                          : ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.grey[900],
                                content: const Text(
                                    'Aby zobaczyć wykres poczekaj na zakończenie pomiaru.',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            );
                    },
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
