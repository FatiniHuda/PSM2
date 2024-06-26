import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'admin_registration.dart'; // Import the admin registration page
import 'forgot_password.dart'; // Import the forgot password page
import 'admin_page.dart'; // Import the admin page
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

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
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Nama Pengguna',
                  border: OutlineInputBorder(),
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
                  border: OutlineInputBorder(),
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading ? CircularProgressIndicator() : Text('Log Masuk'),
                ),
              ),
              SizedBox(height: 20.0),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16.0,
                  ),
                ),
              SizedBox(height: 10.0),
              RichText(
                textAlign: TextAlign.center,
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
                            MaterialPageRoute(
                                builder: (context) => AdminRegistrationPage()),
                          );
                        },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.0),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Lupa Kata Laluan',
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
                        MaterialPageRoute(
                            builder: (context) => ForgotPasswordPage()),
                      );
                    },
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

      try {
        final response = await authenticateUser();
        if (response == 'success') {
          // Show toast message for successful login
          Fluttertoast.showToast(
            msg: 'Log Masuk Berjaya',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );

          // Navigate to the admin page after successful login
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdminPage()),
          );
        } else {
          // Show toast message for failed login
          Fluttertoast.showToast(
            msg: 'Nama pengguna atau kata laluan tidak sah',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      } catch (error) {
        // Show error message for any other errors
        setState(() {
          _errorMessage = 'Ralat: $error';
        });
      } finally {
        // Reset loading state
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<String> authenticateUser() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.0.115/ordering/admin_login.php'),
        body: {
          'username': _usernameController.text,
          'password': _passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        return response.body.trim();
      } else {
        throw 'Failed to connect to the server. Error code: ${response.statusCode}';
      }
    } catch (error) {
      throw 'An error occurred: $error';
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
