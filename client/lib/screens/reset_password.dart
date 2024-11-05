import 'package:client/screens/check_mail.dart';
import 'package:flutter/material.dart';
import 'package:client/theme.dart';
import 'package:client/widgets/primary_button.dart';
import 'package:client/widgets/reset_form.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool _isEmailValid = false;

  void _updateEmailValidity(bool isValid) {
    setState(() {
      _isEmailValid = isValid;
    });
  }

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 250),
                Text('Reset Password', style: titleText),
                const SizedBox(height: 5),
                Text(
                  'Please enter your email address',
                  style: subTitle.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                ResetForm(onEmailValid: _updateEmailValidity),
                const SizedBox(height: 40),
                PrimaryButton(
                  buttonText: 'Reset Password',
                  onPressed: _isEmailValid
                      ? _resetPassword
                      : null, // Enable if email is valid
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _resetPassword() {
    // Implement your reset password logic here
    print("Reset Password button pressed!");

    // Navigate to CheckEmailScreen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CheckEmailScreen()),
    );
  }
}
