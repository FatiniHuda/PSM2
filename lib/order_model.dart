class Order {
  final String id;
  final String customerName;
  final double totalAmount;
  final String status;

  Order({
    required this.id,
    required this.customerName,
    required this.totalAmount,
    required this.status,
  });

  Order copyWith({String? status}) {
    return Order(
      id: this.id,
      customerName: this.customerName,
      totalAmount: this.totalAmount,
      status: status ?? this.status,
    );
  }
}
