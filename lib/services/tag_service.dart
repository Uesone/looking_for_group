import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service per caricare i tag consentiti dal backend (endpoint /tags)
class TagService {
  static const String _baseUrl = 'http://10.0.2.2:3001';

  /// Restituisce la lista di tag consentiti (stringhe).
  static Future<List<String>> fetchAllowedTags() async {
    final url = Uri.parse('$_baseUrl/tags');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<String>();
    } else {
      throw Exception('Errore nel recupero tag (${response.statusCode})');
    }
  }
}
