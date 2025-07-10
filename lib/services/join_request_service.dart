import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class JoinRequestService {
  static Future<void> sendJoinRequest(String eventId, {String? message}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null) throw Exception('Utente non autenticato');

    final response = await http.post(
      Uri.parse('http://10.0.2.2:3001/join-requests/$eventId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'requestMessage': message ?? ''}),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Impossibile inviare la richiesta: ${response.body}');
    }
  }
}
