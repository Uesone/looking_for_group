import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String baseUrl = 'http://10.0.2.2:3001';

  Future<Map<String, dynamic>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null || token.isEmpty) {
      print('ERRORE: token JWT mancante!');
      return null;
    }
    final response = await http.get(
      Uri.parse('$baseUrl/users/me'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Errore getCurrentUser: ${response.statusCode} - ${response.body}');
      return null;
    }
  }

  Future<bool> updateProfile({
    String? city,
    String? bio,
    String? username,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null || token.isEmpty) {
      print('ERRORE: token JWT mancante!');
      // Qui puoi anche fare logout automatico o mostrare un dialog
      return false;
    }
    final body = <String, dynamic>{};
    if (city != null) body['city'] = city;
    if (bio != null) body['bio'] = bio;
    if (username != null) body['username'] = username;
    if (body.isEmpty) return false;

    // Log per debug
    print('Token per update: $token');
    print('Body per update: $body');

    final response = await http.patch(
      Uri.parse('$baseUrl/users/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Errore updateProfile: ${response.statusCode} - ${response.body}');
      return false;
    }
  }
}
