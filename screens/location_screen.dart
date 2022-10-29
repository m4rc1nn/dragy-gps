import 'package:dragy_gps/screens/dragy_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  void checkPermission(bool show) async {
    LocationPermission permission = await Geolocator.checkPermission();
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        show
            ? ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.grey[900],
                  content: const Text(
                      'Odrzucono nadanie uprawnień do lokalizacji.',
                      style: TextStyle(color: Colors.red)),
                ),
              )
            : '';
        return;
      }
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DragyScreen()),
    );
    return;
  }

  @override
  Widget build(BuildContext context) {
    //checkPermission(false);
    return Scaffold(
        appBar: AppBar(
          title: Text('Dragy GPS'),
          centerTitle: true,
        ),
        body: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Hej, zanim zaczniemy...',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
                  Text(
                      'Potrzebujemy uprawnień do lokalizacji, aby móc dokładnie oszacować twoją prędkość podczas poruszania się samochodem. Wystarczy, że klikniesz niżej i zaakceptujesz zgodę.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18)),
                  TextButton(
                      onPressed: () => checkPermission(true),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_on),
                          Text('Nadaj uprawnienia')
                        ],
                      ))
                ])));
  }
}
