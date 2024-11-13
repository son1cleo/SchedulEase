import 'package:flutter/material.dart';

class KeepNoteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('KeepNote')),
      body: Center(
        child: Text(
          'KeepNote Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
