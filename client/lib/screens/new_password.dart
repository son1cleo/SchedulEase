import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:client/theme.dart';
import 'package:client/responsive.dart';
import 'package:http/http.dart' as http;
import 'package:client/screens/login.dart';

class SetNewPasswordScreen extends StatefulWidget {
  @override
  _SetNewPasswordScreenState createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  bool _isObscureConfirm = true;
  String? newPassword;
  String? confirmPassword;
  String? token;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: kDefaultPadding,
          child: Responsive(
            // Layout for mobile
            mobile: buildContent(context, maxWidth: 300),
            // Layout for tablet
            tablet: buildContent(context, maxWidth: 500),
            // Layout for desktop
            desktop: buildContent(context, maxWidth: 700),
          ),
        ),
      ),
    );
  }

  Widget buildContent(BuildContext context, {required double maxWidth}) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Set New Password',
              style: titleText,
            ),
            SizedBox(height: 20),
            _buildPasswordField('Token', true, (value) {
              token = value;
              if (value == null || value.isEmpty) {
                return 'Please enter a token';
              }
              return null;
            }),
            SizedBox(height: 10),
            _buildPasswordField('New Password', true, (value) {
              newPassword = value;
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            }),
            SizedBox(height: 10),
            _buildPasswordField('Confirm Password', false, (value) {
              confirmPassword = value;
              if (value != newPassword) {
                return 'Passwords do not match';
              }
              return null;
            }),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Submit',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField(
      String label, bool isNewPassword, FormFieldValidator<String> validator) {
    return TextFormField(
      obscureText: label == 'Token'
          ? false
          : (isNewPassword
              ? _isObscure
              : _isObscureConfirm), // Always false for Token field
      decoration: InputDecoration(
        labelText: label,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor),
        ),
        // Only show the suffix icon for password fields (New Password, Confirm Password)
        suffixIcon: (label == 'New Password' || label == 'Confirm Password')
            ? IconButton(
                onPressed: () {
                  setState(() {
                    if (isNewPassword) {
                      _isObscure = !_isObscure;
                    } else {
                      _isObscureConfirm = !_isObscureConfirm;
                    }
                  });
                },
                icon: Icon(
                  isNewPassword
                      ? (_isObscure ? Icons.visibility_off : Icons.visibility)
                      : (_isObscureConfirm
                          ? Icons.visibility_off
                          : Icons.visibility),
                  color: kPrimaryColor,
                ),
              )
            : null, // No icon for token field
      ),
      validator: validator,
    );
  }

  // Submit form and call API
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/auth/reset-password/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'token': token,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password updated successfully!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LogInScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to update password. Please try again.')),
        );
      }
    }
  }
}
