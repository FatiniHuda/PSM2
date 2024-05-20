import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'menu_page.dart';

class CustomerPage extends StatefulWidget {
  @override
  _CustomerPageState createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _tableNumberController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitCustomerData(BuildContext context) async {
    final name = _nameController.text;
    final tableNumber = _tableNumberController.text;

    // Validate the form
    if (name.isEmpty || tableNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sila isi semua medan.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Send HTTP POST request
    final url = Uri.parse('http://10.4.29.194/ordering/customer.php');
    final response = await http.post(
      url,
      body: json.encode({'name': name, 'tableNumber': tableNumber}),
      headers: {'Content-Type': 'application/json'},
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      // Successful POST request
      // Navigate to the menu page passing the name and table number
      Navigator.pushNamed(
        context,
        '/menu',
        arguments: {'name': name, 'tableNumber': tableNumber},
      );
    } else {
      // Error handling for unsuccessful POST request
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit customer data. Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maklumat Pelanggan'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nama',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _tableNumberController,
              decoration: InputDecoration(
                labelText: 'Nombor Meja',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : () => _submitCustomerData(context),
                child: _isLoading ? CircularProgressIndicator() : Text(
                  'Proceed to Menu',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ),
            SizedBox(height: 10), // Add some spacing between buttons
          ],
        ),
      ),
    );
  }
}
