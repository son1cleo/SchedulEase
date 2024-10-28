import 'package:client/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:client/theme.dart';

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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Handle password update submission here
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Password updated successfully!')),
                        );
                        // Navigator.pop(
                        //     context); // Redirect to login or other page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LogInScreen()),
                        );
                      }
                    },
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
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
      String label, bool isNewPassword, FormFieldValidator<String> validator) {
    return TextFormField(
      obscureText: isNewPassword ? _isObscure : _isObscureConfirm,
      decoration: InputDecoration(
        labelText: label,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor),
        ),
        suffixIcon: IconButton(
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
                : (_isObscureConfirm ? Icons.visibility_off : Icons.visibility),
            color: kPrimaryColor,
          ),
        ),
      ),
      validator: validator,
    );
  }
}
