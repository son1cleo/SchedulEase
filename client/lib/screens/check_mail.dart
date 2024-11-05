import 'package:client/screens/new_password.dart';
import 'package:flutter/material.dart';
import 'package:client/theme.dart';

class CheckEmailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Define a maximum width for the container
    final maxWidth = 400.0;

    return Scaffold(
      body: Center(
        // Center the content on the screen
        child: Padding(
          padding: kDefaultPadding,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth), // Set max-width
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Check Your Email',
                  style: titleText,
                ),
                SizedBox(height: 20),
                Text(
                  'We’ve sent a password reset link to your email. Please check your inbox and follow the instructions to reset your password.',
                  textAlign: TextAlign.center,
                  style: subTitle,
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    // Navigate back to the login screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SetNewPasswordScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Back to Login',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
