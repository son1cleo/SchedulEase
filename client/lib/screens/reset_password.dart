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

  void _updateEmailValidity(bool isValid) {
    setState(() {
      _isEmailValid = isValid;
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

  void _resetPassword() {
    print("Reset Password button pressed!");

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CheckEmailScreen()),
    );
  }
}
