import 'package:flutter/material.dart';

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
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Form is valid, proceed with password reset logic
                      _resetPassword();
                    }
                  },
                  child: Text('Tukar kata laluan'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _resetPassword() {
    // Implement logic for sending password reset email
    // You can access the entered username and password via _usernameController.text and _passwordController.text respectively
    // Optionally, you can show a confirmation dialog or a toast message here
  }
}
