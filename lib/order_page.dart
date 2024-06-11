import 'package:flutter/material.dart';
import 'menu_item.dart';
import 'payment_page.dart'; // Import the PaymentPage

class OrderPage extends StatelessWidget {
  final List<MenuItem> cartItems;

  OrderPage({required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pesan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ringkasan Pesanan',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0), // Add spacing between the title and the list
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0), // Add vertical spacing between cards
                    child: ListTile(
                      title: Text(
                        item.food_name,
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        '${item.quantity} x RM ${item.food_price.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      trailing: Text(
                        'RM ${(item.food_price * item.quantity).toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16.0), // Add spacing between the list and the total
            Text(
              'Total: RM ${_calculateTotalPrice().toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0), // Add spacing between the total and the button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentPage(
                        cartItems: cartItems,
                        totalPrice: _calculateTotalPrice(),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                  textStyle: TextStyle(fontSize: 18.0),
                ),
                child: Text('Sahkan Pesanan'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateTotalPrice() {
    return cartItems.fold(0.0, (total, current) => total + (current.food_price * current.quantity));
  }
}
