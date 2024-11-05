import 'package:flutter/material.dart';
import 'package:client/theme.dart';

class LogInForm extends StatefulWidget {
  final ValueChanged<bool> onFormValid; // Callback to notify if form is valid

  LogInForm({required this.onFormValid});

  @override
  _LogInFormState createState() => _LogInFormState();
}

class _LogInFormState extends State<LogInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  void _validateForm() {
    final isValid =
        _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
    widget.onFormValid(isValid);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildInputForm('Email', false, _emailController),
        buildInputForm('Password', true, _passwordController),
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
                  icon: _isObscure
                      ? Icon(Icons.visibility_off, color: kTextFieldColor)
                      : Icon(Icons.visibility, color: kPrimaryColor),
                )
              : null,
        ),
      ),
    );
  }
}
