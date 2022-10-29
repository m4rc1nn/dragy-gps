import 'package:dragy_gps/models/speed_measurement.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class SpeedometerProvider with ChangeNotifier {
  double _currentVelocity = 0;
  List<SpeedMeasurement> _speedMeasurementList = [];

  double get velocity => _currentVelocity;
  List<SpeedMeasurement> get speedMeasurementList => _speedMeasurementList;

  void updateSpeed(Position position) {
    double updatedVelocity = (position.speed) * 3.6;
    checkSpeedMeasurements(_currentVelocity, updatedVelocity);
    _currentVelocity = updatedVelocity;
    notifyListeners();
  }

  getSpeedUpdates() async {
    Geolocator.getPositionStream(
            locationSettings: LocationSettings(
                accuracy: LocationAccuracy.high, distanceFilter: 10))
        .listen((position) {
      updateSpeed(position);
    });
  }

  void addSpeedMeasurement(SpeedMeasurement speedMeasurement) {
    _speedMeasurementList.add(speedMeasurement);
    notifyListeners();
  }

  void removeSpeedMeasurement(SpeedMeasurement speedMeasurement) {
    debugPrint(speedMeasurement.toString());
    _speedMeasurementList.remove(speedMeasurement);
    debugPrint(_speedMeasurementList.length.toString());
    notifyListeners();
  }

  void checkSpeedMeasurements(oldVelocity, newVelocity) {
    _speedMeasurementList.forEach((speedMeasurement) {
      if (speedMeasurement.getStatus() == StatusType.WAITING) {
        if (oldVelocity <= speedMeasurement.getStart() &&
            newVelocity > speedMeasurement.getStart()) {
          speedMeasurement.setStartTime();
          Timer timer = Timer.periodic(Duration(milliseconds: 100), (t) {
            double traveledDistance =
                ((((_currentVelocity * 1000 / 3600)) / 2) / 10);
            speedMeasurement.addDistance(traveledDistance);
            speedMeasurement.addToChart(_currentVelocity);
            notifyListeners();
          });
          speedMeasurement.setTimer(timer);
        }
      }

      if (speedMeasurement.getStatus() == StatusType.IN_PROGRESS) {
        if (oldVelocity < speedMeasurement.getEnd() &&
            newVelocity >= speedMeasurement.getEnd()) {
          speedMeasurement.setEndTime();
          speedMeasurement.getTimer()?.cancel();
          debugPrint(speedMeasurement.getAccelerationList().join(', '));
          notifyListeners();
        }
      }
    });
  }
}
