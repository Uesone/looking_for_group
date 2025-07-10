import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Service per la creazione di eventi (ora con supporto tag!)
class EventCreateService {
  static const String _baseUrl = 'http://10.0.2.2:3001';

  /// Crea un nuovo evento.
  /// Aggiungi [tags] per passare la lista dei tag selezionati.
  Future<void> createEvent({
    required String title,
    required String activityType,
    required String location,
    String? notes,
    required DateTime date, // Solo data
    required int maxParticipants,
    required String joinMode, // 'AUTO' o 'MANUAL'
    double? latitude,
    double? longitude,
    String? city,
    required List<String> tags, // AGGIUNTO!
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    final body = jsonEncode({
      "title": title,
      "activityType": activityType,
      "location": location,
      "notes": notes,
      "date": date.toIso8601String().split('T').first,
      "maxParticipants": maxParticipants,
      "joinMode": joinMode,
      "latitude": latitude,
      "longitude": longitude,
      "city": city,
      "tags": tags, // AGGIUNTO!
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
