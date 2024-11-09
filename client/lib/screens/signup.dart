import 'package:flutter/material.dart';
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

  void _updateFormValidity(bool isValid) {
    setState(() {
      _isFormValid = isValid;
    });
  }

  void _toggleTermsAccepted(bool isSelected) {
    setState(() {
      _isTermsAccepted = isSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
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
                  Navigator.push(
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
            onFormValid: _updateFormValidity,
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

  void _signUp() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign Up successful!')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LogInScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Didn\'t Sign Up successfully!')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LogInScreen()),
      );
    }
  }
}