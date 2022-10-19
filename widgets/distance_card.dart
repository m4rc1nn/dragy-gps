import 'package:dragy_gps/screens/chart_screen.dart';
import 'package:flutter/material.dart';
import '../models/distance.dart';

class DistanceCard extends StatelessWidget {
  final Distance distance;
  final Function remove;
  final int id;
  const DistanceCard(
      {required Key key,
      required int this.id,
      required Distance this.distance,
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
              left: BorderSide(color: distance.getColor(), width: 5),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                  leading: Icon(Icons.speed, size: 48),
                  title: Text(
                      distance.start.toString() +
                          ' - ' +
                          distance.end.toString(),
                      style: TextStyle(fontSize: 25)),
                  subtitle: distance.getStatus() == StatusType.FINISHED ||
                          distance.getStatus() == StatusType.IN_PROGRESS
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                              Row(children: <Widget>[
                                Icon(Icons.timer_outlined),
                                Text(' Czas: '),
                                Text((distance
                                                .getEndTime()
                                                .difference(
                                                    distance.getStartTime())
                                                .inMilliseconds /
                                            1000)
                                        .toStringAsFixed(2) +
                                    'sek'),
                              ]),
                            ])
                      : Text('Oczekuje na rozpoczęcie pomiaru...')),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    child: Row(
                        children: <Widget>[Icon(Icons.delete), Text('USUŃ')]),
                    onPressed: () {
                      remove(id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.grey[900],
                          content: Text(
                              'Dodano nowy pomiar ' +
                                  distance.getStart().toString() +
                                  ' - ' +
                                  distance.getEnd().toString(),
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
                      distance.getStatus() == StatusType.FINISHED
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChartScreen(
                                      key: UniqueKey(), distance: distance)),
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
