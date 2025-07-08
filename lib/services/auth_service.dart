import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';

class AuthService {
  static const String _baseUrl = 'http://10.0.2.2:3001'; // Cambia se serve

  Future<bool> login(LoginRequest req) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(req.toJson()),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final token = body['token'] ?? body['jwt'] ?? "";
      final userId = body['userId'] ?? body['id'];
      if (token.isNotEmpty && userId != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', token);
        await prefs.setString(
          'user_id',
          userId.toString(),
        ); // Salva UUID come stringa!
        return true;
      }
    }
    return false;
  }

  Future<bool> register(RegisterRequest req) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(req.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = jsonDecode(response.body);
      final token = body['token'] ?? body['jwt'] ?? "";
      final userId = body['userId'] ?? body['id'];
      if (token.isNotEmpty && userId != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', token);
        await prefs.setString(
          'user_id',
          userId.toString(),
        ); // Salva UUID come stringa!
        return true;
      }
    }
    return false;
  }
}
