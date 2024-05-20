import 'package:flutter/material.dart';

class AdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Implement logout functionality here
              Navigator.pop(context); // Navigate back to the login page
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to the Admin Page!',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Implement any admin functionality here
                // For example, navigate to a product management page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductManagementPage()),
                );
              },
              child: Text('Manage Products'), // Change button text as needed
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Implement any other admin actions here
              },
              child: Text('Perform Admin Action'), // Change button text as needed
            ),
          ],
        ),
      ),
    );
  }
}

// Example of a product management page
class ProductManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Management'),
      ),
      body: Center(
        child: Text('This is the Product Management Page'),
      ),
    );
  }
}
