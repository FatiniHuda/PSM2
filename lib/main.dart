import 'package:flutter/material.dart';
import 'Login.dart'; // Import the admin login page
import 'customer_page.dart'; // Import the customer page

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
              Image.asset(
                'assets/logo.jpg', // Ensure this path matches your asset's location
                width: 250, // Adjust the width as needed
                height: 250, // Adjust the height as needed
              ),
              SizedBox(height: 20), // Add some spacing between the image and text
              Text(
                'Pilih peranan anda:',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
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
              ),
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
