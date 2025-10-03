import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://192.168.1.3:8000/api"; // Your Laravel IP

  // Register
  Future<Map<String, dynamic>> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/mobile/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': username,
        'email': email,
        'password': password,
      }),
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
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
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
    String paymentMethod,
    {required String token} // token required for auth
  ) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.post(
      Uri.parse('$baseUrl/mobile/orders'),
      headers: headers,
      body: jsonEncode({
        'items': items,
        'total': total,
        'payment_method': paymentMethod,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to place order: ${response.body}');
    }
  }
}
