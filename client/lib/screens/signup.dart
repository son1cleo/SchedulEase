import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:client/screens/login.dart';
import 'package:client/theme.dart';
import 'package:client/widgets/checkbox.dart';
import 'package:client/widgets/primary_button.dart';
import 'package:client/widgets/signup_form.dart';
import 'package:client/responsive.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isFormValid = false;
  bool _isTermsAccepted = false;

  String? _firstName;
  String? _lastName;
  String? _email;
  String? _phone;
  String? _password;

  void _updateFormValidity(bool isValid,
      {String? firstName,
      String? lastName,
      String? email,
      String? phone,
      String? password}) {
    setState(() {
      _isFormValid = isValid;
      _firstName = firstName;
      _lastName = lastName;
      _email = email;
      _phone = phone;
      _password = password;
    });
  }

  void _toggleTermsAccepted(bool isSelected) {
    setState(() {
      _isTermsAccepted = isSelected;
    });
  }

  Future<void> _signUp() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final response = await http.post(
          Uri.parse('http://127.0.0.1:5000/auth/register/'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "first_name": _firstName,
            "last_name": _lastName,
            "email": _email,
            "phone_number": _phone,
            "password": _password,
          }),
        );

        if (response.statusCode == 200) {
          // Use Navigator.pushReplacementNamed or Navigator.pop to navigate correctly
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LogInScreen()),
          );
        } else {
          final responseData = jsonDecode(response.body);
          final errorMessage = responseData['message'] ?? 'Sign Up failed';

          // Check if the error is specifically for an existing email
          if (errorMessage.contains('email')) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      'Email already exists. Please use a different email.')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(errorMessage)),
            );
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error: Unable to sign up. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: kDefaultPadding,
            child: Responsive(
              mobile: buildContent(context, maxWidth: 300),
              tablet: buildContent(context, maxWidth: 500),
              desktop: buildContent(context, maxWidth: 700),
            ),
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
          SizedBox(height: 70),
          Text('Create Account', style: titleText),
          SizedBox(height: 5),
          Row(
            children: [
              Text('Already a member?', style: subTitle),
              SizedBox(width: 5),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LogInScreen()),
                  );
                },
                child: Text(
                  'Log In',
                  style: textButton.copyWith(
                    decoration: TextDecoration.underline,
                    decorationThickness: 1,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          SignUpForm(
            formKey: _formKey,
            onFormValid: (isValid, data) {
              _updateFormValidity(isValid,
                  firstName: data['firstName'],
                  lastName: data['lastName'],
                  email: data['email'],
                  phone: data['phone'],
                  password: data['password']);
            },
          ),
          SizedBox(height: 20),
          CheckBox(
            'Agree to terms and conditions.',
            onChanged: _toggleTermsAccepted,
          ),
          SizedBox(height: 20),
          PrimaryButton(
            buttonText: 'Sign Up',
            onPressed: _isFormValid && _isTermsAccepted ? _signUp : null,
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
