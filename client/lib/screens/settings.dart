import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:client/providers/user_provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _firstName;
  String? _lastName;
  String? _phoneNumber;
  String? _currentPassword;
  String? _newPassword;
  String? _confirmPassword;
  bool _isUpdatingPassword = false;
  bool _isSaving = false;
  bool _showCurrentPassword = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (user != null) {
      setState(() {
        _firstName = user['first_name'];
        _lastName = user['last_name'];
        _phoneNumber = user['phone_number'];
      });
    }
  }

  void _saveSettings() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      Map<String, String> updatedFields = {};
      if (_firstName != null && _firstName!.isNotEmpty)
        updatedFields['first_name'] = _firstName!;
      if (_lastName != null && _lastName!.isNotEmpty)
        updatedFields['last_name'] = _lastName!;
      if (_phoneNumber != null && _phoneNumber!.isNotEmpty)
        updatedFields['phone_number'] = _phoneNumber!;

      if (_isUpdatingPassword &&
          _currentPassword != null &&
          _newPassword != null &&
          _confirmPassword == _newPassword) {
        updatedFields['current_password'] = _currentPassword!;
        updatedFields['password'] = _newPassword!;
      }

      setState(() {
        _isSaving = true;
      });

      try {
        await Provider.of<UserProvider>(context, listen: false)
            .updateUserData(updatedFields);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!')),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $error')),
        );
      } finally {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    final email = user?['email'] ?? 'Loading...';

    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: _isSaving
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    // Display Email (Read-only)
                    TextFormField(
                      initialValue: email,
                      decoration: InputDecoration(labelText: 'Email'),
                      readOnly: true,
                    ),
                    // First Name
                    TextFormField(
                      initialValue: _firstName,
                      decoration: InputDecoration(labelText: 'First Name'),
                      onSaved: (value) => _firstName = value,
                    ),
                    // Last Name
                    TextFormField(
                      initialValue: _lastName,
                      decoration: InputDecoration(labelText: 'Last Name'),
                      onSaved: (value) => _lastName = value,
                    ),
                    // Phone Number
                    TextFormField(
                      initialValue: _phoneNumber,
                      decoration: InputDecoration(labelText: 'Phone Number'),
                      keyboardType: TextInputType.phone,
                      onSaved: (value) => _phoneNumber = value,
                      validator: (value) {
                        if (value != null &&
                            value.isNotEmpty &&
                            !RegExp(r'^\d{10,15}$').hasMatch(value)) {
                          return 'Enter a valid phone number';
                        }
                        return null;
                      },
                    ),
                    // Toggle Password Update
                    SwitchListTile(
                      title: Text('Update Password'),
                      value: _isUpdatingPassword,
                      onChanged: (value) {
                        setState(() {
                          _isUpdatingPassword = value;
                        });
                      },
                    ),
                    // Password Fields
                    if (_isUpdatingPassword) ...[
                      // Current Password
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Current Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _showCurrentPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _showCurrentPassword = !_showCurrentPassword;
                              });
                            },
                          ),
                        ),
                        obscureText: !_showCurrentPassword,
                        onSaved: (value) => _currentPassword = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your current password';
                          }
                          return null;
                        },
                      ),
                      // New Password
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'New Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isNewPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isNewPasswordVisible = !_isNewPasswordVisible;
                              });
                            },
                          ),
                        ),
                        obscureText: !_isNewPasswordVisible,
                        onChanged: (value) {
                          setState(() {
                            _newPassword =
                                value.trim(); // Update state immediately
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a new password';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isConfirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordVisible =
                                    !_isConfirmPasswordVisible;
                              });
                            },
                          ),
                        ),
                        obscureText: !_isConfirmPasswordVisible,
                        onChanged: (value) {
                          setState(() {
                            _confirmPassword =
                                value.trim(); // Update state immediately
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _newPassword) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                    ],
                    // Save Button
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveSettings,
                      child: Text('Save Changes'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
