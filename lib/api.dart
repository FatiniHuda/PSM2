import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://192.168.0.115/ordering';

  static Future<http.Response> addToCart(int customerId, int foodId, int quantity, double price) {
    return http.post(
      Uri.parse('$baseUrl/add_to_cart.php'),
      body: {
        'customer_id': customerId.toString(),
        'food_id': foodId.toString(),
        'quantity': quantity.toString(),
        'price': price.toString(),
      },
    );
  }

  static Future<List<dynamic>> getCartItems(int customerId) async {
    final response = await http.get(Uri.parse('$baseUrl/cart.php?customer_id=$customerId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load cart items');
    }
  }

  static Future<http.Response> updateCartItem(int customerId, int foodId, int quantity) {
    return http.post(
      Uri.parse('$baseUrl/update_cart.php'),
      body: {
        'customer_id': customerId.toString(),
        'food_id': foodId.toString(),
        'quantity': quantity.toString(),
      },
    );
  }

  static Future<http.Response> removeFromCart(int customerId, int foodId) {
    return http.post(
      Uri.parse('$baseUrl/remove_from_cart.php'),
      body: {
        'customer_id': customerId.toString(),
        'food_id': foodId.toString(),
      },
    );
  }
}

