import 'package:ad_up/components/break.dart';
import 'package:flutter/material.dart';

import '../components/class.dart';

class DebugScreen extends StatefulWidget {
  @override
  State<DebugScreen> createState() => _DebugScreen();
}

class _DebugScreen extends State<DebugScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [Break(start: DateTime(2026, 4, 7, 14, 15), end: DateTime(2026, 4, 7, 14, 30)),
              Class(name: "Cours", teacher: "Prof", location: "Lieu", start: DateTime(2026, 4, 7, 14, 30), end: DateTime(2026, 4, 7, 16), type: "TD"),
              Break(start: DateTime(2026, 4, 7, 16), end: DateTime(2026, 4, 7, 17, 15))
            ],
          ),
        ),
      ),
    );
  }

}