import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

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
  bool _isLoading = false;

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
              _buildUsernameField(),
              SizedBox(height: 20.0),
              _buildEmailField(),
              SizedBox(height: 20.0),
              _buildPasswordField(),
              SizedBox(height: 20.0),
              _buildConfirmPasswordField(),
              SizedBox(height: 20.0),
              _buildRegisterButton(),
              SizedBox(height: 10.0),
              _buildErrorMessage(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUsernameField() {
    return TextFormField(
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
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'E-mel',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Sila masukkan alamat e-mel';
        }
        // Add email format validation here if needed
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Kata Laluan',
        border: OutlineInputBorder(),
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
        // Add password strength validation here if needed
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      decoration: InputDecoration(
        labelText: 'Sahkan Kata Laluan',
        border: OutlineInputBorder(),
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
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _registerUser,
        child: _isLoading ? CircularProgressIndicator() : Text('Daftar'),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Text(
      _errorMessage,
      style: TextStyle(
        color: Colors.red,
      ),
    );
  }

  bool _validateInputs() {
    if (_usernameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Sila isi semua medan',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      Fluttertoast.showToast(
        msg: 'Kata laluan tidak sepadan',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }
    return true;
  }

  Future<void> _registerUser() async {
    if (!_validateInputs()) return;

    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final response = await http.post(
        Uri.parse('http://192.168.0.115/ordering/admin_register.php'),
        body: {
          'username': _usernameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        _showSuccessDialog();
      } else if (response.statusCode == 400) {
        setState(() {
          _errorMessage = 'Pendaftaran gagal. Data tidak sah.';
        });
        _showErrorDialog();
      } else {
        setState(() {
          _errorMessage = 'Pendaftaran gagal. Sila cuba lagi.';
        });
        _showErrorDialog();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Ralat: $e';
      });
      _showErrorDialog();
    } finally {
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
