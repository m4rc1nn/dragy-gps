import 'package:dragy_gps/widgets/bottom_navigation_bar.dart';
import 'package:dragy_gps/widgets/distance_card.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/circular_progress_bar.dart';
import '../models/speed_measurement.dart';
import 'package:provider/provider.dart';
import '../providers/speedometr_provider.dart';
import '../utils/numeric_utils.dart';

class DragyScreen extends StatefulWidget {
  const DragyScreen({super.key});

  @override
  State<DragyScreen> createState() => _DragyScreenState();
}

class _DragyScreenState extends State<DragyScreen> {
  String _valueMin = '';
  String _valueMax = '';
  TextEditingController _textFieldMin = TextEditingController();
  TextEditingController _textFieldMax = TextEditingController();

  void addSpeedMeasurement() {
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
    SpeedMeasurement speedMeasurement = SpeedMeasurement();
    speedMeasurement.setStart(min);
    speedMeasurement.setEnd(max);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.grey[900],
        content: Text(
            'Dodano nowy pomiar ' + min.toString() + ' - ' + max.toString(),
            style: TextStyle(color: Colors.green)),
      ),
    );

    context.read<SpeedometerProvider>().addSpeedMeasurement(speedMeasurement);
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
                    addSpeedMeasurement();
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                  })
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final providerData = Provider.of<SpeedometerProvider>(context);
    providerData.getSpeedUpdates();
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
                      Text(providerData.velocity.toStringAsFixed(0),
                          style: const TextStyle(
                              fontSize: 42, fontWeight: FontWeight.bold)),
                      Text('km/h',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold))
                    ],
                  )
                ]..addAll(
                    context
                        .watch<SpeedometerProvider>()
                        .speedMeasurementList
                        .map((speedMeasurement) {
                      return CircularProgressBar(
                          key: UniqueKey(),
                          radius: (150 +
                              (10 *
                                  context
                                      .watch<SpeedometerProvider>()
                                      .speedMeasurementList
                                      .indexOf(speedMeasurement))),
                          speed: context.watch<SpeedometerProvider>().velocity,
                          speedMeasurement: speedMeasurement);
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
            children: <Widget>[]..addAll(context
                  .watch<SpeedometerProvider>()
                  .speedMeasurementList
                  .map((speedMeasurement) {
                return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: DistanceCard(
                        key: UniqueKey(),
                        id: context
                            .watch<SpeedometerProvider>()
                            .speedMeasurementList
                            .indexOf(speedMeasurement),
                        remove: (speedMeasurement) => {
                              context
                                  .read<SpeedometerProvider>()
                                  .removeSpeedMeasurement(speedMeasurement)
                            },
                        speedMeasurement: speedMeasurement));
              }).toList()),
          ),
        ],
      ))),
      bottomNavigationBar: DragyBottomNavigationBar(index: 0),
    );
  }
}
