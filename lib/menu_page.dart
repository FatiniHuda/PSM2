import 'dart:convert';
import 'package:applikasi_pesanan_makanan/cart_page.dart';
import 'package:applikasi_pesanan_makanan/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MenuItem {
  final String name;
  final String image;
  final String price;

  MenuItem({
    required this.name,
    required this.image,
    required this.price,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      name: json['name'],
      image: json['image'],
      price: json['price'],
    );
  }

  get category => null;
}

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<MenuItem> _menuItems = [];

  @override
  void initState() {
    super.initState();
    _fetchMenuItems();
  }

  Future<void> _fetchMenuItems() async {
    try {
      final response = await http.get(Uri.parse('http://localhost/food.php'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          _menuItems = jsonData.map((data) => MenuItem.fromJson(data)).toList();
        });
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      print('Error fetching menu items: $e');
      // Implement error handling (e.g., show error message to user)
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Menu'),
          actions: [
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                // Navigate to cart page when the cart button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartPage()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                // Navigate to home page when logout button is pressed
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePage()),
                );
              },
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  'Makanan',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Minuman',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildMenuGridView(_menuItems.where((item) => item.category == 'makanan').toList(), context),
            _buildMenuGridView(_menuItems.where((item) => item.category == 'minuman').toList(), context),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuGridView(List<MenuItem> items, BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 0.75,
      padding: EdgeInsets.all(16.0),
      mainAxisSpacing: 16.0,
      crossAxisSpacing: 16.0,
      children: items.map((item) {
        return GestureDetector(
          onTap: () {
            // Handle item tap
            print('Item ${item.name} tapped');
          },
          child: Card(
            elevation: 2.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      item.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 4.0),
                  child: Text(
                    'RM ${item.price}',
                    style: TextStyle(fontSize: 16.0, color: Colors.grey[700]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle adding item to cart
                      print('Item ${item.name} added to cart');
                    },
                    child: Text('Add to Cart'),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
