import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserProvider with ChangeNotifier {
  String? _token;
  Map<String, dynamic>? _user;

  String? get token => _token;
  Map<String, dynamic>? get user => _user;
  String? get userId => _user?['_id'];

  bool get isLoggedIn => _token != null;

  // Load user data from local storage
  Future<void> loadUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('token');
      final userData = prefs.getString('user');
      if (userData != null) {
        _user = jsonDecode(userData);
      }
      notifyListeners();
    } catch (error) {
      print('Error loading user data: $error');
      throw Exception('Failed to load user data');
    }
  }

  // Login and save user data
  Future<void> login(String token, Map<String, dynamic> userData) async {
    try {
      _token = token;
      _user = userData;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('user', jsonEncode(userData));
      notifyListeners();
    } catch (error) {
      print('Error during login: $error');
      throw Exception('Failed to log in');
    }
  }

  // Logout and clear user data
  Future<void> logout() async {
    try {
      _token = null;
      _user = null;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('user');
      notifyListeners();
    } catch (error) {
      print('Error during logout: $error');
      throw Exception('Failed to log out');
    }
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
          // Save updated user data to local storage
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('user', jsonEncode(_user));
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

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    final userData = prefs.getString('user');
    if (userData != null) {
      _user = json.decode(userData);
    }
    notifyListeners();
  }

  Future<void> saveUserData(String token, Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    _token = token;
    _user = userData;
    await prefs.setString('token', token);
    await prefs.setString('user', json.encode(userData));
    notifyListeners();
  }

  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
    _token = null;
    _user = null;
    notifyListeners();
  }

  Future<void> updateUserData(Map<String, String> updatedFields) async {
    final prefs = await SharedPreferences.getInstance();
    final token =
        prefs.getString('token'); // Ensure token is stored and retrieved
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await http.put(
      Uri.parse('http://127.0.0.1:5000/auth/update'), // Correct URL
      headers: {
        'Content-Type': 'application/json',
        'x-auth-token': token, // Pass the token here
      },
      body: jsonEncode(updatedFields),
    );

    if (response.statusCode != 200) {
      throw Exception('Error: ${response.body}');
    }
  }
}
