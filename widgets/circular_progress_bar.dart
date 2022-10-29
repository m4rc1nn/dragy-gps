import 'package:flutter/material.dart';
import '../models/speed_measurement.dart';

class CircularProgressBar extends StatefulWidget {
  final int radius;
  final double speed;
  final SpeedMeasurement speedMeasurement;

  const CircularProgressBar(
      {required Key key,
      required this.radius,
      required this.speed,
      required this.speedMeasurement})
      : super(key: key);

  @override
  _CircularProgressBarState createState() => _CircularProgressBarState();
}

class _CircularProgressBarState extends State<CircularProgressBar> {
  late int radius;
  late double speed;
  late SpeedMeasurement speedMeasurement;

  double _value = 0.0;

  @override
  void initState() {
    super.initState();
    setState(() {
      _value = widget.speedMeasurement.getStatus() == StatusType.WAITING
          ? 0.0
          : (widget.speed - widget.speedMeasurement.getStart()) /
              (widget.speedMeasurement.getEnd() -
                  widget.speedMeasurement.getStart());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: widget.radius.toDouble(),
        width: widget.radius.toDouble(),
        child: CircularProgressIndicator(
          backgroundColor: Colors.black,
          strokeWidth: 7.5,
          value: _value,
          valueColor: AlwaysStoppedAnimation<Color?>(
              widget.speedMeasurement.getColor()),
        ));
  }
}
