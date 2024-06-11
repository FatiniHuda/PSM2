import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'menu_item.dart'; // Import the MenuItem model

class ProductService {
  static const String apiUrl = 'http://192.168.0.115/ordering/food.php';

  Future<List<MenuItem>> fetchMenuItems() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => MenuItem.fromJson(json)).toList();
      } else {
        print('Server error: ${response.statusCode} ${response.body}');
        throw Exception('Failed to load menu items');
      }
    } catch (e) {
      print('Error fetching menu items: $e');
      throw Exception('Failed to load menu items');
    }
  }

  Future<void> addMenuItem(MenuItem menuItem) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(menuItem.toJson()),
      );

      if (response.statusCode != 201) {
        print('Server error: ${response.statusCode} ${response.body}');
        throw Exception('Failed to add menu item');
      }
    } catch (e) {
      print('Error adding menu item: $e');
      throw Exception('Failed to add menu item');
    }
  }

  Future<void> updateMenuItem(MenuItem menuItem) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/${menuItem.food_id}'), // Assuming food_id is unique
        headers: {'Content-Type': 'application/json'},
        body: json.encode(menuItem.toJson()),
      );

      if (response.statusCode != 200) {
        print('Server error: ${response.statusCode} ${response.body}');
        throw Exception('Failed to update menu item');
      }
    } catch (e) {
      print('Error updating menu item: $e');
      throw Exception('Failed to update menu item');
    }
  }

  Future<void> deleteMenuItem(int foodId) async {
    try {
      final response = await http.delete(Uri.parse('$apiUrl/$foodId'));

      if (response.statusCode != 200) {
        print('Server error: ${response.statusCode} ${response.body}');
        throw Exception('Failed to delete menu item');
      }
    } catch (e) {
      print('Error deleting menu item: $e');
      throw Exception('Failed to delete menu item');
    }
  }
}
