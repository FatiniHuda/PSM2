import 'package:flutter/material.dart';
import 'Login.dart'; // Import the admin login page
import 'customer_page.dart';
import 'menu_page.dart'; // Import the menu page

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Pesanan Makanan KMAC',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halaman Utama'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Pilih peranan anda:',
                style: TextStyle(fontSize: 18.0),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20), // Add some spacing between text and buttons
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to the customer page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CustomerPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blueGrey, // Background color
                    onPrimary: Colors.white, // Text color
                    padding: EdgeInsets.symmetric(vertical: 15), // Button padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Button border radius
                    ),
                  ),
                  child: Text('Pelanggan'),
                ),
              ), // Remove this extra parenthesis
              SizedBox(height: 10), // Add some spacing between buttons
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to admin login page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdminLoginPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blueGrey, // Background color
                    onPrimary: Colors.white, // Text color
                    padding: EdgeInsets.symmetric(vertical: 15), // Button padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Button border radius
                    ),
                  ),
                  child: Text('Pentadbir'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
