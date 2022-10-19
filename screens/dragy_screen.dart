import 'package:dragy_gps/widgets/bottom_navigation_bar.dart';
import 'package:dragy_gps/widgets/distance_card.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/circular_progress_bar.dart';
import '../models/distance.dart';
import '../screens/location_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sensors/sensors.dart';
import 'dart:math';

class DragyScreen extends StatefulWidget {
  const DragyScreen({super.key});

  @override
  State<DragyScreen> createState() => _DragyScreenState();
}

class _DragyScreenState extends State<DragyScreen> {
  List<Distance> _distanceList = [];
  double _lastSavedVelocity = 0.0;
  double _velocity = 0.0;
  Timer? _timer;
  String _valueMin = '';
  String _valueMax = '';
  TextEditingController _textFieldMin = TextEditingController();
  TextEditingController _textFieldMax = TextEditingController();

  @override
  void initState() {
    userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      _onAccelerate(event);
    });
    Timer.periodic(Duration(milliseconds: 100), (Timer t) {
      setState(() {
        _distanceList = [..._distanceList];
      });
    });
    initExampleRides();
    super.initState();
  }

  void _onAccelerate(UserAccelerometerEvent event) {
    double newVelocity =
        sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

    if ((newVelocity - _velocity).abs() < 1) {
      return;
    }
    debugPrint('---');
    debugPrint(_velocity.toString() + ' < 0 | 0 >= ' + newVelocity.toString());

    List<Distance> distanceList = List.from(_distanceList);
    distanceList.forEach((distance) {
      if ((newVelocity > distance.getStart()) &&
          (_velocity <= distance.getStart()) &&
          distance.getStatus() == StatusType.WAITING) {
        distance.setStartTime();
      }
      if ((newVelocity >= distance.getEnd()) &&
          (distance.getStatus() == StatusType.IN_PROGRESS)) {
        distance.setEndTime();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.grey[900],
            content: const Text('Zakończono pomiar.',
                style: TextStyle(color: Colors.white)),
          ),
        );
      }
      if (distance.getStatus() == StatusType.IN_PROGRESS) {
        //double meterDistance = (((actuallSpeed + _speed) / 2) * 1000) / 3600;
        //distance.addDistance(meterDistance / 10);
        distance.addToChart(newVelocity);
      }
    });

    setState(() {
      _distanceList = distanceList;
    });

    setState(() {
      if (newVelocity < 1)
        _velocity = 0.0;
      else
        _velocity = newVelocity;
    });
  }

  /*double getActuallSpeed() {
    Geolocator.getCurrentPosition(
            forceAndroidLocationManager: true,
            desiredAccuracy: LocationAccuracy.best)
        .then((position) => setState(() {
              _currentSpeed = position.speed;
              debugPrint(position.speedAccuracy.toString());
            }));
    return _currentSpeed;
  }*/

  void removeDistance(int id) {
    setState(() {
      _distanceList.remove(_distanceList[id]);
    });
  }

  bool isNumeric(String s) {
    try {
      int.parse(s);
      return true;
    } catch (e) {
      return false;
    }
  }

  void addDistance() {
    if (!isNumeric(_valueMin) || !isNumeric(_valueMax)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.grey[900],
          content: const Text('Podane wartości nie są liczbami.',
              style: TextStyle(color: Colors.red)),
        ),
      );
      return;
    }
    int min = int.parse(_valueMin);
    int max = int.parse(_valueMax);
    if (min >= max) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.grey[900],
          content: const Text(
              'Wartość OD nie może być mniejsza bądź równa wartości DO.',
              style: TextStyle(color: Colors.red)),
        ),
      );
      return;
    }
    Distance distance = Distance();
    distance.setStart(min);
    distance.setEnd(max);
    setState(() {
      _distanceList.add(distance);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.grey[900],
        content: Text(
            'Dodano nowy pomiar ' + min.toString() + ' - ' + max.toString(),
            style: TextStyle(color: Colors.green)),
      ),
    );
  }

  void initExampleRides() {
    Distance distance = Distance();
    distance.setStart(0);
    distance.setEnd(100);
    _distanceList.add(distance);
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Dodaj nowy pomiar'),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              TextField(
                onChanged: (value) {
                  setState(() {
                    _valueMin = value;
                  });
                },
                controller: _textFieldMin,
                decoration: InputDecoration(hintText: 'Pomiar od'),
              ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    _valueMax = value;
                  });
                },
                controller: _textFieldMax,
                decoration: InputDecoration(hintText: 'Pomiar do'),
              ),
            ]),
            actions: <Widget>[
              TextButton(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[Icon(Icons.add), Text('Dodaj')]),
                  onPressed: () {
                    addDistance();
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                  })
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
          child: Center(
              child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Column(
                    children: [
                      Text(_velocity.toInt().toString(),
                          style: const TextStyle(
                              fontSize: 42, fontWeight: FontWeight.bold)),
                      Text('km/h',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold))
                    ],
                  )
                ]..addAll(
                    _distanceList.map((distance) {
                      return CircularProgressBar(
                          key: UniqueKey(),
                          radius:
                              (150 + (10 * _distanceList.indexOf(distance))),
                          speed: _velocity,
                          distance: distance);
                    }).toList(),
                  ),
              )),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  _displayTextInputDialog(context);
                },
                icon: const Icon(
                  // <-- Icon
                  Icons.add,
                  size: 28.0,
                ),
                label: const Text('Dodaj nowy'), // <-- Text
              )),
          Column(
            children: <Widget>[]..addAll(_distanceList.map((distance) {
                return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: DistanceCard(
                        key: UniqueKey(),
                        id: _distanceList.indexOf(distance),
                        remove: (id) => {removeDistance(id)},
                        distance:
                            _distanceList[_distanceList.indexOf(distance)]));
              }).toList()),
          ),
        ],
      ))),
      bottomNavigationBar: DragyBottomNavigationBar(index: 0),
    );
  }
}
