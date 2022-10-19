import 'package:flutter/material.dart';
import '../models/distance.dart';

class CircularProgressBar extends StatefulWidget {
  final int radius;
  final double speed;
  final Distance distance;

  const CircularProgressBar(
      {required Key key,
      required this.radius,
      required this.speed,
      required this.distance})
      : super(key: key);

  @override
  _CircularProgressBarState createState() => _CircularProgressBarState();
}

class _CircularProgressBarState extends State<CircularProgressBar> {
  late int radius;
  late double speed;
  late Distance distance;

  double _value = 0.0;

  @override
  void initState() {
    super.initState();
    setState(() {
      _value = widget.distance.getStatus() == StatusType.WAITING
          ? 0.0
          : (widget.speed - widget.distance.getStart()) /
              (widget.distance.getEnd() - widget.distance.getStart());
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
          valueColor:
              AlwaysStoppedAnimation<Color?>(widget.distance.getColor()),
        ));
  }
}
