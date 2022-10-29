import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';

class SpeedMeasurement {
  int? start;
  int? end;
  Color? color;
  DateTime? startTime;
  DateTime? endTime;
  Timer? timer;
  StatusType status = StatusType.WAITING;
  double distanceTraveled = 0;
  List<double> accelerationList = [];

  SpeedMeasurement() {
    this.color =
        Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  }

  void setStart(int start) {
    this.start = start;
    this.accelerationList = [];
  }

  void setEnd(int end) {
    this.end = end;
  }

  int getStart() {
    return this.start ?? 0;
  }

  int getEnd() {
    return this.end ?? 0;
  }

  Color getColor() {
    return this.color ?? Colors.black;
  }

  void setStartTime() {
    this.status = StatusType.IN_PROGRESS;
    this.startTime = DateTime.now();
  }

  void setEndTime() {
    this.status = StatusType.FINISHED;
    this.endTime = DateTime.now();
  }

  DateTime getStartTime() {
    return this.startTime ?? DateTime.now();
  }

  DateTime getEndTime() {
    return this.endTime ?? DateTime.now();
  }

  Timer? getTimer() {
    return this.timer;
  }

  void setTimer(Timer timer) {
    this.timer = timer;
  }

  void setStatus(StatusType status) {
    this.status = status;
  }

  StatusType getStatus() {
    return this.status;
  }

  void addDistance(double distance) {
    if (this.status != StatusType.FINISHED) this.distanceTraveled += distance;
  }

  double getDistanceTraveled() {
    return this.distanceTraveled;
  }

  void addToChart(double speed) {
    this.accelerationList.add(speed);
  }

  List<double> getAccelerationList() {
    return this.accelerationList;
  }
}

enum StatusType { WAITING, IN_PROGRESS, FINISHED }
