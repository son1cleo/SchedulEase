import 'package:flutter/material.dart';
import 'package:client/theme.dart';

class ResetForm extends StatefulWidget {
  final ValueChanged<bool> onEmailValid; // Callback to notify if email is valid

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
    final isValid = _emailController.text.isNotEmpty;
    widget.onEmailValid(isValid);
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
