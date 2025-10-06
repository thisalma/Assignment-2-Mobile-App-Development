import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8000/api";

  // Register
  Future<Map<String, dynamic>> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/mobile/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': username, 'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register: ${response.body}');
    }
  }

  // Login
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/mobile/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  // Place Order
  Future<Map<String, dynamic>> placeOrder(
    List<Map<String, dynamic>> items,
    double total,
    String paymentMethod, {
    required String token,
  }) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.post(
      Uri.parse('$baseUrl/mobile/orders'),
      headers: headers,
      body: jsonEncode({'items': items, 'total': total, 'payment_method': paymentMethod}),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to place order: ${response.body}');
    }
  }

  // Get Order History
  Future<List<Map<String, dynamic>>> getOrders({required String token}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(
      Uri.parse('$baseUrl/mobile/orders'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body); // Map<String, dynamic>
      final orders = data['orders'] as List<dynamic>; // ✅ extract list
      return orders.map((e) => Map<String, dynamic>.from(e)).toList(); // convert each order to Map
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized. Please login again.');
    } else {
      throw Exception('Failed to fetch orders: ${response.body}');
    }
  }
}
