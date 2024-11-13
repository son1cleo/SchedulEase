// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:client/responsive.dart';
import 'package:client/screens/login.dart';
import 'package:provider/provider.dart';
import 'package:client/providers/user_provider.dart';


class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

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
                      // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => SmartSchedulingScreen()));
                    },
                  ),
                  ListTile(
                    title: Text('KeepNote'),
                    onTap: () {

                    },
                  ),
                  ListTile(
                    title: Text('Subscription'),
                    onTap: () {
                      // Add navigation for Subscription
                      // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => SubscriptionScreen()));
                    },
                  ),
                  ListTile(
                    title: Text('Settings'),
                    onTap: () {
                      // Add navigation for Settings
                      // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
                    },
                  ),
                  ListTile(
                    title: Text('Signout'),
                    onTap: () async {
                      // Log out the user
                      await userProvider.logout();

                      // Navigate back to the login screen after logout
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LogInScreen()),
                      );
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
