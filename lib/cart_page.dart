import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}
class _CartPageState extends State<CartPage> {
  List<String> _cartItems = []; // Maintain list of cart items

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: ListView.builder(
        itemCount: _cartItems.length,
        itemBuilder: (context, index) {
          final cartItem = _cartItems[index];
          return ListTile(
            title: Text(cartItem),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Remove item from cart list
                setState(() {
                  _cartItems.removeAt(index);
                });
              },
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              // Implement functionality to place order
              print('Place order button pressed');
            },
            child: Text('Place Order'),
          ),
        ),
      ),
    );
  }
}

