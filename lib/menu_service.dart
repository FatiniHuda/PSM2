import 'package:http/http.dart' as http;
import 'dart:convert';
import 'menu_item.dart';

class MenuService {
  static const String apiUrl = 'http://192.168.112.131/ordering';

  Future<List<MenuItem>> fetchMenuItems() async {
    final response = await http.get(Uri.parse('$apiUrl/food.php'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => MenuItem.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load menu items');
    }
  }

  Future<void> addMenuItem(MenuItem menuItem) async {
    final response = await http.post(
      Uri.parse('$apiUrl/add_food.php'), // Assuming the endpoint for adding food
      headers: {'Content-Type': 'application/json'},
      body: json.encode(menuItem.toJson()),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Failed to add menu item');
    }
  }

  Future<void> updateMenuItem(MenuItem menuItem) async {
    final response = await http.put(
      Uri.parse('$apiUrl/update_food.php/${menuItem.food_id}'), // Assuming the endpoint for updating food
      headers: {'Content-Type': 'application/json'},
      body: json.encode(menuItem.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update menu item');
    }
  }

  Future<void> deleteMenuItem(int foodId) async {
    final response = await http.delete(Uri.parse('$apiUrl/delete_food.php/$foodId')); // Assuming the endpoint for deleting food

    if (response.statusCode != 200) {
      throw Exception('Failed to delete menu item');
    }
  }
}
