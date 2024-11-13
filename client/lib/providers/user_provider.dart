import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserProvider with ChangeNotifier {
  String? _token;
  Map<String, dynamic>? _user;

  String? get token => _token;
  Map<String, dynamic>? get user => _user;
  bool get isLoggedIn => _token != null;

  // Load user data from local storage
  Future<void> loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    final userData = prefs.getString('user');
    if (userData != null) {
      _user = jsonDecode(userData);
    }
    notifyListeners();
  }

  // Login and save user data
  Future<void> login(String token, Map<String, dynamic> userData) async {
    _token = token;
    _user = userData;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('user', jsonEncode(userData));
    notifyListeners();
  }

  // Logout and clear user data
  Future<void> logout() async {
    _token = null;
    _user = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
    notifyListeners();
  }

  // Refresh the subscription status from the backend
  Future<void> refreshUserSubscription() async {
    if (_user != null) {
      final userId =
          _user!['_id']; // Ensure you're using the correct field for userId

      if (userId == null) {
        print('User ID is null, cannot refresh subscription status');
        return; // Handle the case where the userId is missing
      }

      print('Refreshing subscription for userId: $userId'); // Log the userId

      try {
        final response = await http.post(
          Uri.parse('http://127.0.0.1:5000/subscribe/refresh/'),
          headers: {
            'Authorization': 'Bearer $_token', // Use token for authentication
            'Content-Type': 'application/json', // Ensure proper header for JSON
          },
          body: jsonEncode({
            'userId': userId,
          }),
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          print('User data updated successfully: ${responseData['user']}');
          _user = responseData['user']; // Update the user data
          notifyListeners(); // Notify listeners to refresh UI
        } else {
          print(
              'Failed to refresh subscription. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
          throw Exception('Failed to refresh subscription status');
        }
      } catch (error) {
        print('Error refreshing subscription: $error');
        throw Exception('Error refreshing subscription: $error');
      }
    } else {
      print('User is null, cannot refresh subscription status');
    }
  }
}
