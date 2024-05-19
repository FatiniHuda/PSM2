import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminRegistrationPage extends StatefulWidget {
  @override
  _AdminRegistrationPageState createState() => _AdminRegistrationPageState();
}

class _AdminRegistrationPageState extends State<AdminRegistrationPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isPasswordObscure = true;
  bool _isConfirmPasswordObscure = true;
  String _errorMessage = '';
  bool _isLoading = false; // Add this line to track loading state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pendaftaran Pentadbir'),
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
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'E-mel',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Sila masukkan alamat e-mel';
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
                    return 'Sila sahkan kata laluan';
                  }
                  if (value != _passwordController.text) {
                    return 'Kata laluan tidak sepadan';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              SizedBox( // Adjusted the button width
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _registerUser, // Change _login to _registerUser
                  child: _isLoading ? CircularProgressIndicator() : Text('Daftar'),
                ),
              ),
              SizedBox(height: 10.0), // Added space
              Text(
                _errorMessage,
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _validateInputs() {
    if (_usernameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Sila isi semua medan';
      });
      return false;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = 'Kata laluan tidak sepadan';
      });
      return false;
    }
    return true;
  }

  Future<void> _registerUser() async {
    try {
      // Validate inputs first
      if (!_validateInputs()) {
        return; // Stop registration process if inputs are not valid
      }

      final username = _usernameController.text;
      final email = _emailController.text;
      final password = _passwordController.text;

      // Set loading state
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      // Perform registration
      final response = await http.post(
        Uri.parse('http://10.4.29.194/ordering/admin_register.php'), // Replace with your actual backend URL
        body: {
          'username': username,
          'email': email,
          'password': password,
        },
      );

      // Check registration response
      if (response.statusCode == 200) {
        // Registration successful
        print('Registration successful');
        _showSuccessDialog(); // Show success dialog
      } else {
        // Registration failed
        print('Registration failed with status: ${response.statusCode}');
        // Display error message
        setState(() {
          _errorMessage = 'Pendaftaran gagal. Sila cuba lagi.';
        });
        _showErrorDialog(); // Show error dialog
      }
    } catch (e) {
      print('Error registering user: $e');
      setState(() {
        _errorMessage = 'Ralat: $e';
      });
      _showErrorDialog(); // Show error dialog
    } finally {
      // Reset loading state
      setState(() {
        _isLoading = false;
      });
    }
  }


  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Berjaya"),
          content: Text("Pendaftaran berjaya."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Ralat"),
          content: Text("Pendaftaran gagal. Sila cuba lagi."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
