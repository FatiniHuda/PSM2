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

    if (name.isEmpty || tableNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill out all fields.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MenuPage(
              name: name,
              tableNumber: tableNumber,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit customer data. Please try again.'),
            duration: Duration(seconds: 2),
          ),
        );
        print('Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Network error. Please check your connection and try again.'),
          duration: Duration(seconds: 2),
        ),
      );
      print('Network error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Information'),
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
                labelText: 'Name',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _tableNumberController,
              decoration: InputDecoration(
                labelText: 'Table Number',
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
          ],
        ),
      ),
    );
  }
}
