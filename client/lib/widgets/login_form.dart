import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:client/theme.dart';

class LogInForm extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final ValueChanged<bool> onFormValid;

  LogInForm({
    required this.emailController,
    required this.passwordController,
    required this.onFormValid,
  });

  @override
  _LogInFormState createState() => _LogInFormState();
}

class _LogInFormState extends State<LogInForm> {
  bool _isObscure = true;

  @override
  void initState() {
    super.initState();
    widget.emailController.addListener(_validateForm);
    widget.passwordController.addListener(_validateForm);
  }

  void _validateForm() {
    final isValid = widget.emailController.text.isNotEmpty &&
        widget.passwordController.text.isNotEmpty;
    widget.onFormValid(isValid);
  }

  @override
  void dispose() {
    widget.emailController.removeListener(_validateForm);
    widget.passwordController.removeListener(_validateForm);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildInputForm('Email', false, widget.emailController),
        buildInputForm('Password', true, widget.passwordController),
      ],
    );
  }

  Padding buildInputForm(
      String label, bool pass, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: controller,
        obscureText: pass ? _isObscure : false,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: kTextFieldColor),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: kPrimaryColor),
          ),
          suffixIcon: pass
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                  icon: Icon(
                    _isObscure ? Icons.visibility_off : Icons.visibility,
                    color: kTextFieldColor,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
