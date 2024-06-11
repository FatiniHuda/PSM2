import 'order_model.dart';
import 'receipt_model.dart'; // Add this import

class OrderService {
  final List<Order> _mockOrders = [
    Order(id: '1', customerName: 'Alice', totalAmount: 120.00, status: 'Pending'),
    Order(id: '2', customerName: 'Bob', totalAmount: 150.50, status: 'Completed'),
    Order(id: '3', customerName: 'Charlie', totalAmount: 75.75, status: 'Shipped'),
  ];

  Future<List<Order>> fetchOrders() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    return _mockOrders;
  }

  Future<void> deleteOrder(String orderId) async {
    _mockOrders.removeWhere((order) => order.id == orderId);
    await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay
  }

  Future<void> updateOrder(Order updatedOrder) async {
    int index = _mockOrders.indexWhere((order) => order.id == updatedOrder.id);
    if (index != -1) {
      _mockOrders[index] = updatedOrder;
    }
    await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay
  }

  Future<Receipt> generateReceipt(String orderId) async {
    final order = _mockOrders.firstWhere((order) => order.id == orderId);
    final receipt = Receipt(
      orderId: order.id,
      customerName: order.customerName,
      totalAmount: order.totalAmount,
      items: [
        ReceiptItem(description: 'Item 1', price: 50.0, quantity: 1),
        ReceiptItem(description: 'Item 2', price: 70.0, quantity: 1),
      ],
      date: DateTime.now(),
    );
    await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay
    return receipt;
  }
}
