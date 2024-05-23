import 'package:flutter/material.dart';
import 'menu_item.dart';

class CartPage extends StatefulWidget {
  final List<MenuItem> cartItems;

  CartPage({required this.cartItems});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late List<MenuItem> _cartItems;

  @override
  void initState() {
    super.initState();
    _cartItems = widget.cartItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: _cartItems.isEmpty
          ? Center(child: Text('Your cart is empty'))
          : ListView.builder(
        itemCount: _cartItems.length,
        itemBuilder: (context, index) {
          final cartItem = _cartItems[index];
          return ListTile(
            leading: Image.memory(cartItem.food_image,
                width: 50, height: 50, fit: BoxFit.cover),
            title: Text(cartItem.food_name),
            subtitle: Text('RM ${cartItem.food_price.toStringAsFixed(2)}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (cartItem.quantity > 1) {
                        cartItem.quantity--;
                      } else {
                        _showRemoveConfirmationDialog(index);
                      }
                    });
                  },
                ),
                Text('${cartItem.quantity}'),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      cartItem.quantity++;
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
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Total: RM ${_calculateTotalPrice().toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: _cartItems.isEmpty ? null : _placeOrder,
                child: Text('Place Order'),
              ),
            ],
          ),
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
                setState(() {
                  _cartItems.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: Text('Remove'),
            ),
          ],
        );
      },
    );
  }

  void _placeOrder() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Order Placed'),
          content: Text('Your order has been placed successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _cartItems.clear();
                });
              },
              child: Text('OK'),
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
