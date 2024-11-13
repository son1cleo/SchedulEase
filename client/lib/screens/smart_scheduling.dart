import 'package:flutter/material.dart';

class SmartSchedulingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Smart Scheduling')),
      body: Center(
        child: Text(
          'Smart Scheduling Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
