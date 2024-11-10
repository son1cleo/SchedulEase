import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:client/screens/check_mail.dart';
import 'package:flutter/material.dart';
import 'package:client/theme.dart';
import 'package:client/widgets/primary_button.dart';
import 'package:client/widgets/reset_form.dart';
import 'package:client/responsive.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool _isEmailValid = false;
  String _email = '';

  void _updateEmailValidity(bool isValid, String email) {
    setState(() {
      _isEmailValid = isValid;
      _email = email;
    });
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
            onPressed: _isEmailValid ? _resetPassword : null,
          ),
        ],
      ),
    );
  }

  Future<void> _resetPassword() async {
    final url = Uri.parse('http://127.0.0.1:5000/auth/reset-password-request/');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': _email}),
      );

      if (response.statusCode == 200) {
        // Navigate to check email screen on success
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CheckEmailScreen()),
        );
      } else {
        // Display error message for email already exists or other errors
        final responseData = jsonDecode(response.body);
        final errorMessage = responseData['error'] ?? 'An error occurred';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send reset request. Try again.')),
      );
    }
  }
}
