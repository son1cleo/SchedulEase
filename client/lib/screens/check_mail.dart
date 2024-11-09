import 'package:client/screens/new_password.dart';
import 'package:flutter/material.dart';
import 'package:client/theme.dart';
import 'package:client/responsive.dart';

class CheckEmailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: kDefaultPadding,
          child: Responsive(
            // Define the layout for mobile
            mobile: buildContent(context, maxWidth: 300),
            // Define the layout for tablet if different from mobile
            tablet: buildContent(context, maxWidth: 500),
            // Define the layout for desktop
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
                MaterialPageRoute(builder: (context) => SetNewPasswordScreen()),
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
    );
  }
}
