import 'package:flutter/material.dart';
import 'package:client/theme.dart';

class ResetForm extends StatefulWidget {
  final Function(bool, String)
      onEmailValid; // Updated callback to include email

  ResetForm({required this.onEmailValid});

  @override
  _ResetFormState createState() => _ResetFormState();
}

class _ResetFormState extends State<ResetForm> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateEmail);
  }

  void _validateEmail() {
    final email = _emailController.text;
    final isValid =
        email.isNotEmpty && RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
    widget.onEmailValid(isValid, email); // Pass both validity and email
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: TextFormField(
        controller: _emailController,
        decoration: InputDecoration(
          hintText: 'Email',
          hintStyle: TextStyle(color: kTextFieldColor),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: kPrimaryColor),
          ),
        ),
      ),
    );
  }
}
