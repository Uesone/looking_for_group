import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/event_feed.dart';

class EventService {
  // Sostituisci con l'URL del tuo backend!
  static const String _baseUrl =
      'http://10.0.2.2:3001'; // Cambia con il tuo indirizzo reale

  Future<List<EventFeed>> fetchEventFeed() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    final response = await http.get(
      Uri.parse('$_baseUrl/events/feed'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => EventFeed.fromJson(json)).toList();
    } else {
      throw Exception(
        'Errore nel caricamento degli eventi (${response.statusCode})',
      );
    }
  }
}
