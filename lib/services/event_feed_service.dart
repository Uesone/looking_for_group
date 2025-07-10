import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/event_feed.dart';

/// Service per caricare il feed eventi dal backend.
/// Mostra sempre eventi (con o senza geo), e passa la geo SOLO se attiva.
class EventFeedService {
  static const String _baseUrl = 'http://10.0.2.2:3001';

  Future<List<EventFeed>> fetchEventFeed({
    int page = 0,
    int size = 10,
    double? latitude,
    double? longitude,
    double radiusKm = 25,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    // Costruzione query dinamica
    final Map<String, String> queryParams = {
      'page': page.toString(),
      'size': size.toString(),
      'radiusKm': radiusKm.toString(),
    };
    if (latitude != null && longitude != null) {
      queryParams['lat'] = latitude.toString();
      queryParams['lon'] = longitude.toString();
    }

    final uri = Uri.parse(
      '$_baseUrl/events/feed',
    ).replace(queryParameters: queryParams);

    final response = await http.get(
      uri,
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
