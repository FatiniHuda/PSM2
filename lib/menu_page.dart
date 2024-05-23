import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'cart_page.dart';
import 'menu_item.dart';

class MenuPage extends StatefulWidget {
  final String name;
  final String tableNumber;

  MenuPage({required this.name, required this.tableNumber});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<MenuItem> _menuItems = [];
  List<MenuItem> _cartItems = [];
  Map<String, List<MenuItem>> _categorizedMenuItems = {
    'minuman': [],
    'nasi': [],
    'lontong': [],
    'mee/meehun': []
  };

  @override
  void initState() {
    super.initState();
    _fetchMenuItems();
  }

  Future<void> _fetchMenuItems() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.4.29.194/ordering/food.php'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          _menuItems = jsonData.map((data) => MenuItem.fromJson(data)).toList();
          _categorizeMenuItems();
        });
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching menu items: $e');
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to fetch menu items. Please try again later.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _addToCart(MenuItem item) {
    setState(() {
      int index = _cartItems.indexWhere((i) => i.food_name == item.food_name);
      if (index != -1) {
        _cartItems[index].quantity++;
      } else {
        _cartItems.add(MenuItem(
          food_name: item.food_name,
          food_price: item.food_price,
          food_image: item.food_image,
          food_category: item.food_category,
          quantity: 1,
        ));
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.food_name} added to cart.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _categorizeMenuItems() {
    _categorizedMenuItems['minuman'] =
        _menuItems.where((item) => item.food_category == 'minuman').toList();
    _categorizedMenuItems['nasi'] =
        _menuItems.where((item) => item.food_category == 'nasi').toList();
    _categorizedMenuItems['lontong'] =
        _menuItems.where((item) => item.food_category == 'lontong').toList();
    _categorizedMenuItems['mee/meehun'] =
        _menuItems.where((item) => item.food_category == 'mee/meehun').toList();
  }

  Future<void> _logout() async {
    bool? confirmLogout = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pengesahan log keluar'),
          content: Text('Adakah anda pasti mahu log keluar?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Log keluar'),
            ),
          ],
        );
      },
    );

    if (confirmLogout == true) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Menu untuk ${widget.name} di meja ${widget.tableNumber}'),
          actions: [
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartPage(cartItems: _cartItems)),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: _logout,
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: 'Minuman'),
              Tab(text: 'Nasi'),
              Tab(text: 'Lontong'),
              Tab(text: 'Mee/Meehun'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildMenuGridView(_categorizedMenuItems['minuman']!),
            _buildMenuGridView(_categorizedMenuItems['nasi']!),
            _buildMenuGridView(_categorizedMenuItems['lontong']!),
            _buildMenuGridView(_categorizedMenuItems['mee/meehun']!),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuGridView(List<MenuItem> items) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.60,
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 2,
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
                  child: item.food_image.isNotEmpty
                      ? Image.memory(
                    item.food_image,
                    fit: BoxFit.cover,
                  )
                      : Placeholder(),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.food_name,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        'RM ${item.food_price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ElevatedButton(
                  onPressed: () {
                    _addToCart(item);
                    print('Item ${item.food_name} ditambah ke troli');
                  },
                  child: Text('Tambah ke troli'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}


