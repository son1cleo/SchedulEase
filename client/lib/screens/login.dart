import 'package:flutter/material.dart';
import 'package:client/screens/reset_password.dart';
import 'package:client/screens/signup.dart';
import 'package:client/theme.dart';
import 'package:client/widgets/login_form.dart';
import 'package:client/widgets/primary_button.dart';
import 'package:client/responsive.dart';

class LogInScreen extends StatefulWidget {
  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  bool _isFormValid = false;

  void _updateFormValidity(bool isValid) {
    setState(() {
      _isFormValid = isValid;
    });
  }

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
            LogInForm(onFormValid: _updateFormValidity),
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
              onPressed: _isFormValid ? _logInUser : null,
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _logInUser() {
    // Implement your login logic here
    print("Log In button pressed!");
  }
}
