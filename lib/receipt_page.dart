import 'package:flutter/material.dart';
import 'receipt_model.dart';

class ReceiptPage extends StatelessWidget {
  final Receipt receipt;

  const ReceiptPage({Key? key, required this.receipt}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ID: ${receipt.orderId}', style: TextStyle(fontSize: 18)),
            Text('Pelanggan: ${receipt.customerName}', style: TextStyle(fontSize: 18)),
            Text('Tarikh: ${receipt.date}', style: TextStyle(fontSize: 18)),
            Divider(),
            ...receipt.items.map((item) {
              return ListTile(
                title: Text(item.description),
                subtitle: Text('Kuantiti: ${item.quantity}'),
                trailing: Text('RM ${item.price.toStringAsFixed(2)}'),
              );
            }).toList(),
            Divider(),
            Text('Jumlah Harga: RM ${receipt.totalAmount.toStringAsFixed(2)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
