import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EventCreateService {
  static const String _baseUrl = 'http://10.0.2.2:3001';

  Future<void> createEvent({
    required String title,
    required String activityType,
    required String location,
    String? notes,
    required DateTime date, // Solo data
    required int maxParticipants,
    required String joinMode, // 'AUTO' o 'MANUAL'
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    final body = jsonEncode({
      "title": title,
      "activityType": activityType,
      "location": location,
      "notes": notes,
      "date": date.toIso8601String().split('T').first, // solo yyyy-MM-dd
      "maxParticipants": maxParticipants,
      "joinMode": joinMode,
    });

    final url = Uri.parse('$_baseUrl/events');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: body,
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
        'Errore nella creazione evento (${response.statusCode}): ${response.body}',
      );
    }
  }
}
