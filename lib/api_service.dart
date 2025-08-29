import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "http://your-laravel-url/api";

  /// Register user
  static Future<Map<String, dynamic>> register(
      String name, String email, String password) async {
    final url = Uri.parse("$baseUrl/register");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
        "password_confirmation": password,
      }),
    );

    return _handleResponse(response);
  }

  /// Login user
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final url = Uri.parse("$baseUrl/login");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    return _handleResponse(response);
  }

  /// Logout user
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
  }

  /// Handle HTTP response
  static Map<String, dynamic> _handleResponse(http.Response response) {
    final data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return {"success": true, "data": data};
    } else {
      return {
        "success": false,
        "message": data["message"] ?? "Something went wrong"
      };
    }
  }
}
