import 'package:flutter/material.dart';
import 'package:client/responsive.dart'; // Make sure to import the Responsive class

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: Colors.blue,
      ),
      drawer: Responsive.isMobile(context) ||
              Responsive.isTablet(context) ||
              Responsive.isDesktop(context)
          ? Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Text(
                      'Menu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text('Smart Scheduling'),
                    onTap: () {
                      // Add navigation for Smart Scheduling
                    },
                  ),
                  ListTile(
                    title: Text('KeepNote'),
                    onTap: () {
                      // Add navigation for KeepNote
                    },
                  ),
                  ListTile(
                    title: Text('Subscription'),
                    onTap: () {
                      // Add navigation for Subscription
                    },
                  ),
                  ListTile(
                    title: Text('Settings'),
                    onTap: () {
                      // Add navigation for Settings
                    },
                  ),
                  ListTile(
                    title: Text('Signout'),
                    onTap: () {
                      // Add signout functionality
                    },
                  ),
                ],
              ),
            )
          : null, // No drawer on desktop view
      body: Center(
        child: Text(
          'Welcome to the Dashboard!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
