import 'package:flutter/material.dart';
import 'menu_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CartPage extends StatefulWidget {
  final int customerId;
  final List<MenuItem> cartItems;

  CartPage({required this.cartItems, required this.customerId});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late List<MenuItem> _cartItems = [];

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
  }

  Future<void> _fetchCartItems() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.0.115/ordering/cart.php?customer_id=${widget.customerId}'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          _cartItems = jsonData.map((data) => MenuItem.fromJson(data)).toList();
        });
      } else {
        _showErrorDialog('Failed to fetch cart items. Please try again.');
      }
    } catch (e) {
      _showErrorDialog('Error fetching cart items: $e');
    }
  }

  Future<void> _updateCartItem(MenuItem item, int quantity) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.0.115/ordering/update_cart.php'),
        body: {
          'customer_id': widget.customerId.toString(),
          'food_id': item.food_id.toString(),
          'quantity': quantity.toString(),
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          item.quantity = quantity;
        });
      } else {
        _showErrorDialog('Failed to update item quantity.');
      }
    } catch (e) {
      _showErrorDialog('Error updating item: $e');
    }
  }

  Future<void> _removeCartItem(MenuItem item) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.0.115/ordering/remove_from_cart.php'),
        body: {
          'customer_id': widget.customerId.toString(),
          'food_id': item.food_id.toString(),
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _cartItems.remove(item);
        });
      } else {
        _showErrorDialog('Failed to remove item from cart.');
      }
    } catch (e) {
      _showErrorDialog('Error removing item: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: _cartItems.isEmpty
          ? Center(child: Text('Your cart is empty'))
          : _buildCartList(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildCartList() {
    return ListView.builder(
      itemCount: _cartItems.length,
      itemBuilder: (context, index) {
        final cartItem = _cartItems[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: ListTile(
            leading: Image.memory(cartItem.food_image,
                width: 50, height: 50, fit: BoxFit.cover),
            title: Text(
              cartItem.food_name,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              'RM ${cartItem.food_price.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16.0),
            ),
            trailing: _buildQuantityControls(cartItem, index),
          ),
        );
      },
    );
  }

  Widget _buildQuantityControls(MenuItem cartItem, int index) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: () {
            setState(() {
              if (cartItem.quantity > 1) {
                _updateCartItem(cartItem, cartItem.quantity - 1);
              } else {
                _showRemoveConfirmationDialog(index);
              }
            });
          },
        ),
        Text(
          '${cartItem.quantity}',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
        ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            setState(() {
              _updateCartItem(cartItem, cartItem.quantity + 1);
            });
          },
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            _showRemoveConfirmationDialog(index);
          },
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return BottomAppBar(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Total: RM ${_calculateTotalPrice().toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: _cartItems.isEmpty
                  ? null
                  : () {
                // Navigate to order page or handle order placement
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                textStyle: TextStyle(fontSize: 18.0),
              ),
              child: Text('Place Order'),
            ),
          ],
        ),
      ),
    );
  }

  void _showRemoveConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Remove Item'),
          content: Text('Are you sure you want to remove this item from the cart?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _removeCartItem(_cartItems[index]);
                Navigator.of(context).pop();
              },
              child: Text('Remove'),
            ),
          ],
        );
      },
    );
  }

  double _calculateTotalPrice() {
    return _cartItems.fold(0.0, (total, current) => total + (current.food_price * current.quantity));
  }
}
