import 'package:flutter/material.dart';
import 'admin_profile_page.dart';
import 'product_management_page.dart';
import 'order_management_page.dart';
import 'admin_profile_page.dart'; // Import the AdminProfilePage
import 'main.dart'; // Make sure to import your HomePage

class AdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halaman Pentadbir'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Navigate back to the home page and clear the stack
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()), // Your home page
                    (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // Number of columns in the grid
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: <Widget>[
            _buildGridItem(
              context,
              icon: Icons.shopping_cart,
              title: 'Pengurusan Produk',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductManagementPage()),
                );
              },
            ),
            _buildGridItem(
              context,
              icon: Icons.list,
              title: 'Pengurusan Pesanan',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrderManagementPage()),
                );
              },
            ),
            _buildGridItem(
              context,
              icon: Icons.person,
              title: 'Profil Pentadbir',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminProfilePage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 48.0),
            SizedBox(height: 16.0),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
