import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'admin_registration.dart'; // Import the admin registration page
import 'forgot_password.dart'; // Import the forgot password page
import 'admin_page.dart'; // Import the admin page

class AdminLoginPage extends StatefulWidget {
  @override
  _AdminLoginPageState createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log Masuk Pentadbir'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
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
                      _isObscure ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  ),
                ),
                obscureText: _isObscure,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Sila masukkan kata laluan';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              SizedBox( // Adjusted the button width
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading ? CircularProgressIndicator() : Text('Log Masuk'),
                ),
              ),
              SizedBox(height: 10.0), // Added space
              Text(
                _errorMessage,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 10.0), // Added space
              RichText(
                text: TextSpan(
                  text: "Tiada akaun? ",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Daftar',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          // Navigate to registration page when "Daftar" is tapped
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AdminRegistrationPage()),
                          );
                        },
                    ),
                    TextSpan(text: ' | '), // Added separator
                    TextSpan(
                      text: 'Lupa Kata Laluan', // Added "Forgot Password?" link
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Navigate to forgot password page when "Lupa Kata Laluan" is tapped
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                          );
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _login() async {
    if (_validateForm()) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final username = _usernameController.text;
      final password = _passwordController.text;

      // Simulate login process (replace with your actual login logic)
      await Future.delayed(Duration(seconds: 2));

      // Example login logic: check if username and password are valid
      if (username == 'admin' && password == 'password') {
        // Navigate to the admin page when login is successful
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdminPage()),
        );
      } else {
        // Show error message if login fails
        setState(() {
          _errorMessage = 'Nama pengguna atau kata laluan tidak sah';
          _isLoading = false;
        });
      }
    }
  }

  bool _validateForm() {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Sila isi semua medan';
      });
      return false;
    }
    return true;
  }
}
