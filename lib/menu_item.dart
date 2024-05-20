import 'dart:convert';
import 'dart:typed_data';

class MenuItem {
  final String name;
  final Uint8List image;
  final String price;
  final String category;

  MenuItem({
    required this.name,
    required this.image,
    required this.price,
    required this.category,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      name: json['name'],
      image: base64Decode(json['image']),
      price: json['price'],
      category: json['category'],
    );
  }
}
