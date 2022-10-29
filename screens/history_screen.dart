import 'package:dragy_gps/models/speed_measurement.dart';
import 'package:flutter/material.dart';
import '../widgets/bottom_navigation_bar.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Row(children: []),
      ),
      bottomNavigationBar: DragyBottomNavigationBar(index: 1),
    );
  }
}
