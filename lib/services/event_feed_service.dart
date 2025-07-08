import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/event_feed.dart';

class EventFeedService {
  static const String _baseUrl = 'http://10.0.2.2:3001';

  Future<List<EventFeed>> fetchEventFeed({int page = 0, int size = 10}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    final url = Uri.parse('$_baseUrl/events/feed?page=$page&size=$size');

    final response = await http.get(
      url,
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
