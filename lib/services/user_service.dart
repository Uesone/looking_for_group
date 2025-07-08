import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_dashboard.dart';
import '../models/user_public_profile.dart';

class UserService {
  static const String baseUrl = 'http://10.0.2.2:3001'; // Cambia se serve

  // DASHBOARD PRIVATA: Usa sempre /me/dashboard! NON leggere userId dalle prefs!
  Future<UserDashboard> fetchDashboard() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token') ?? '';

    if (token.isEmpty) {
      throw Exception('Utente non autenticato.');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/users/me/dashboard'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return UserDashboard.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw Exception('Sessione scaduta. Fai login di nuovo!');
    } else {
      throw Exception('Impossibile caricare la dashboard');
    }
  }

  // PROFILO PUBBLICO: Usa sempre /users/{id}/profile
  Future<UserPublicProfile> fetchUserPublicProfile(String userId) async {
    if (userId.isEmpty) throw Exception('ID utente mancante.');
    final response = await http.get(
      Uri.parse('$baseUrl/users/$userId/profile'),
    );
    if (response.statusCode == 200) {
      return UserPublicProfile.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Impossibile caricare il profilo utente');
    }
  }
}
