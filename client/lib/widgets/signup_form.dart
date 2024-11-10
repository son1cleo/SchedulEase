import 'package:flutter/material.dart';
import 'package:client/theme.dart';

class SignUpForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final void Function(bool isValid, Map<String, String> formData) onFormValid;

  SignUpForm({required this.formKey, required this.onFormValid});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool _isObscure = true;
  String _password = '';
  String? _firstName, _lastName, _email, _phone;
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      onChanged: _validateForm,
      child: Column(
        children: [
          buildInputForm('First Name', false, (value) {
            if (value == null || value.isEmpty) {
              return 'First Name is required';
            }
            _firstName = value;
            return null;
          }),
          buildInputForm('Last Name', false, (value) {
            if (value == null || value.isEmpty) {
              return 'Last Name is required';
            }
            _lastName = value;
            return null;
          }),
          buildInputForm('Email', false, (value) {
            if (value == null || value.isEmpty) {
              return 'Email is required';
            }
            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
              return 'Enter a valid email';
            }
            _email = value;
            return null;
          }),
          buildInputForm('Phone', false, (value) {
            if (value == null || value.isEmpty) {
              return 'Phone number is required';
            }
            if (!RegExp(r'^\+?[0-9]{7,15}$').hasMatch(value)) {
              return 'Enter a valid phone number';
            }
            _phone = value;
            return null;
          }, controller: _phoneController),
          buildInputForm('Password', true, (value) {
            if (value == null || value.isEmpty) {
              return 'Password is required';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            _password = value;
            return null;
          }),
          buildInputForm('Confirm Password', true, (value) {
            if (value == null || value.isEmpty) {
              return 'Confirm your password';
            }
            if (value != _password) {
              return 'Passwords do not match';
            }
            return null;
          }),
        ],
      ),
    );
  }

  Padding buildInputForm(
      String hint, bool isPassword, FormFieldValidator<String> validator,
      {TextEditingController? controller}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword ? _isObscure : false,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: kTextFieldColor),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: kPrimaryColor)),
          suffixIcon: isPassword
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                  icon: _isObscure
                      ? Icon(
                          Icons.visibility_off,
                          color: kTextFieldColor,
                        )
                      : Icon(
                          Icons.visibility,
                          color: kPrimaryColor,
                        ))
              : null,
        ),
        validator: validator,
      ),
    );
  }

  void _validateForm() {
    final isFormValid = widget.formKey.currentState?.validate() ?? false;
    widget.onFormValid(isFormValid, {
      'firstName': _firstName ?? '',
      'lastName': _lastName ?? '',
      'email': _email ?? '',
      'phone': _phone ?? '',
      'password': _password
    });
  }
}
