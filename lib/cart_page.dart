import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CartItem {
  final String name;
  final String imagePath;
  int quantity;

  CartItem({
    required this.name,
    required this.imagePath,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      name: json['name'],
      imagePath: json['imagePath'],
      quantity: json['quantity'],
    );
  }
}

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem> _cartItems = [];

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
  }

  Future<void> _fetchCartItems() async {
    try {
      final response = await http.get(Uri.parse('your_api_endpoint'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          _cartItems = jsonData.map((data) => CartItem.fromJson(data)).toList();
        });
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      print('Error fetching cart items: $e');
      // Implement error handling (e.g., show error message to user)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: _buildCartList(),
      bottomNavigationBar: _buildCheckoutButton(),
    );
  }

  Widget _buildCartList() {
    if (_cartItems.isEmpty) {
      return Center(
        child: Text('Your cart is empty'),
      );
    } else {
      return ListView.builder(
        itemCount: _cartItems.length,
        itemBuilder: (context, index) {
          CartItem cartItem = _cartItems[index];
          return ListTile(
            leading: Image.network(
              cartItem.imagePath,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(cartItem.name),
            subtitle: Text('Quantity: ${cartItem.quantity}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    _adjustQuantity(cartItem, -1);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    _adjustQuantity(cartItem, 1);
                  },
                ),
              ],
            ),
          );
        },
      );
    }
  }

  Widget _buildCheckoutButton() {
    return ElevatedButton(
      onPressed: () {
        // Implement checkout logic
        print('Checkout button pressed');
      },
      child: Text('Checkout'),
    );
  }

  void _adjustQuantity(CartItem cartItem, int change) {
    setState(() {
      int newQuantity = cartItem.quantity + change;
      if (newQuantity > 0) {
        cartItem.quantity = newQuantity;
      } else {
        _cartItems.remove(cartItem);
      }
    });
  }
}
