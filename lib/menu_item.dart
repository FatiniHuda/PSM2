import 'dart:convert';
import 'dart:typed_data';

class MenuItem {
  final int food_id;
  final String food_name;
  final double food_price;
  final Uint8List food_image;
  final String food_category;
  int quantity;

  MenuItem({
    required this.food_id,
    required this.food_name,
    required this.food_price,
    required this.food_image,
    required this.food_category,
    this.quantity = 0,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      food_id: json['food_id'] is int ? json['food_id'] : int.tryParse(json['food_id']) ?? 0,
      food_name: json['food_name'] ?? '',
      food_price: json['food_price'] is double ? json['food_price'] : double.tryParse(json['food_price'].toString()) ?? 0.0,
      food_image: base64Decode(json['food_image'] ?? ''),
      food_category: json['food_category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'food_id': food_id,
      'food_name': food_name,
      'food_price': food_price,
      'food_image': base64Encode(food_image),
      'food_category': food_category,
    };
  }
}
