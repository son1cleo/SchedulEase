import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text(
          'Welcome to the Dashboard!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
