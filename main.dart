import 'package:dragy_gps/screens/dragy_screen.dart';
import 'package:dragy_gps/screens/location_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/speedometr_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (ctx) => SpeedometerProvider(),
        child: MaterialApp(
          theme: ThemeData(brightness: Brightness.dark),
          home: const LocationScreen(),
        ));
  }
}
