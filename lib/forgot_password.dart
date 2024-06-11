import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>(); // Key for the form
  bool _isPasswordObscure = true;
  bool _isConfirmPasswordObscure = true;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  Future<void> _resetPassword() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    final url = 'http://192.168.209.131/ordering/';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'username': username,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          // Show success message
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Success'),
              content: Text('Password reset successful.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop(); // Navigate back to login screen
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        } else {
          // Show error message
          _showErrorDialog(responseData['message']);
        }
      } else {
        // Show error message
        _showErrorDialog('Failed to reset password. Please try again.');
      }
    } catch (error) {
      // Show error message
      _showErrorDialog('An error occurred. Please try again.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lupa kata laluan'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Nama Pengguna',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Sila masukkan nama pengguna';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Kata Laluan',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordObscure ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordObscure = !_isPasswordObscure;
                        });
                      },
                    ),
                  ),
                  obscureText: _isPasswordObscure,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Sila masukkan kata laluan';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Sahkan Kata Laluan',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordObscure ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordObscure = !_isConfirmPasswordObscure;
                        });
                      },
                    ),
                  ),
                  obscureText: _isConfirmPasswordObscure,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Sila masukkan kata laluan pengesahan';
                    } else if (value != _passwordController.text) {
                      return 'Kata laluan tidak sepadan';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.0),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Form is valid, proceed with password reset logic
                        _resetPassword();
                      }
                    },
                    child: Text('Tukar kata laluan'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
