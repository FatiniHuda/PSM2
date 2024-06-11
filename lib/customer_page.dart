import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'menu_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomerPage extends StatefulWidget {
  @override
  _CustomerPageState createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _tableNumber = '';

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var url = 'http://192.168.0.115/ordering/customer.php';
      var response = await http.post(
        Uri.parse(url),
        body: {
          'name': _name,
          'table_number': _tableNumber,
        },
      );

      if (response.headers['content-type']?.contains('application/json') == true) {
        var responseData;
        try {
          responseData = json.decode(response.body);
          print("Response data: $responseData"); // Debugging statement
        } catch (e) {
          Fluttertoast.showToast(
            msg: 'Error decoding response from server.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
          return;
        }

        if (responseData['status'] == 'success') {
          Fluttertoast.showToast(
            msg: 'Successfully submitted!',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );

          int customerId = responseData['customer_id'];

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MenuPage(
                name: _name,
                tableNumber: _tableNumber,
                customerId: customerId,
              ),
            ),
          );
        } else {
          Fluttertoast.showToast(
            msg: responseData['message'] ?? 'Unknown error occurred.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: 'Unexpected response from server. Please try again later.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selamat Datang'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Sila masukkan nama dan nombor meja:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(),
                  hintText: 'Isikan nama',
                  contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Sila isikan nama anda';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nombor meja',
                  border: OutlineInputBorder(),
                  hintText: 'Isikan nombor meja',
                  contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Sila isikan nombor meja';
                  }
                  return null;
                },
                onSaved: (value) {
                  _tableNumber = value!;
                },
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Teruskan ke menu'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
