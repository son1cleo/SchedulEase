import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:client/screens/reset_password.dart';
import 'package:client/screens/signup.dart';
import 'package:client/theme.dart';
import 'package:client/widgets/login_form.dart';
import 'package:client/widgets/primary_button.dart';
import 'package:client/responsive.dart';
import 'package:client/screens/dashboard.dart';
import 'package:provider/provider.dart';
import 'package:client/providers/user_provider.dart';

class LogInScreen extends StatefulWidget {
  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  bool _isFormValid = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Callback function to handle form validity
  void _updateFormValidity(bool isValid) {
    setState(() {
      _isFormValid = isValid;
    });
  }

  // Callback function to handle login
  Future<void> _logInUser() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/auth/login/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Check if 'token' and 'user' fields are present in the response
        if (data != null && data['token'] != null && data['user'] != null) {
          final token = data['token'];
          final userData = data['user'];

          // Store token and user data in UserProvider
          await Provider.of<UserProvider>(context, listen: false)
              .login(token, userData);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DashboardScreen()),
          );
        } else {
          // Handle missing fields in response
          _showSnackBar('Invalid response from server. Please try again.');
        }
      } else {
        final message = jsonDecode(response.body)['error'] ?? 'Login failed';
        _showSnackBar(message);
      }
    } catch (e) {
      print("Error occurred: $e");
      _showSnackBar('An error occurred. Please try again.');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: kDefaultPadding,
          child: Responsive(
            mobile: buildContent(context, maxWidth: 300),
            tablet: buildContent(context, maxWidth: 500),
            desktop: buildContent(context, maxWidth: 700),
          ),
        ),
      ),
    );
  }

  Widget buildContent(BuildContext context, {required double maxWidth}) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 120),
            Text('Welcome Back', style: titleText),
            SizedBox(height: 5),
            Row(
              children: [
                Text('New to this app?', style: subTitle),
                SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    );
                  },
                  child: Text(
                    'Sign Up',
                    style: textButton.copyWith(
                      decoration: TextDecoration.underline,
                      decorationThickness: 1,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            LogInForm(
              emailController: _emailController,
              passwordController: _passwordController,
              onFormValid: _updateFormValidity,
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ResetPasswordScreen()),
                );
              },
              child: Text(
                'Forgot password?',
                style: TextStyle(
                  color: kZambeziColor,
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                  decorationThickness: 1,
                ),
              ),
            ),
            SizedBox(height: 20),
            PrimaryButton(
              buttonText: 'Log In',
              onPressed: _isFormValid ? _logInUser : null, // Trigger login
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
