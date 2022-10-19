import 'package:flutter/material.dart';
import '../screens/history_screen.dart';

class DragyBottomNavigationBar extends StatefulWidget {
  final int? index;
  const DragyBottomNavigationBar({this.index, super.key});

  @override
  State<DragyBottomNavigationBar> createState() =>
      _DragyBottomNavigationBarState();
}

class _DragyBottomNavigationBarState extends State<DragyBottomNavigationBar> {
  void _onItemTapped(int index) {
    if (index == widget.index) return;
    switch (index) {
      case 0:
        Navigator.of(context).pop();
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HistoryScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.speed),
          label: 'Dragy',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'History',
        ),
      ],
      currentIndex: widget.index ?? 0,
      selectedItemColor: Colors.purple[800],
      onTap: _onItemTapped,
    );
  }
}
