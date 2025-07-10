import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_dashboard.dart';
import '../models/user_public_profile.dart';
import '../models/user_profile_update.dart';

/// Service centralizzato per tutte le API utente (dashboard, profilo, upload foto, update posizione ecc.)
class UserService {
  static const String baseUrl = 'http://10.0.2.2:3001'; // Cambia per prod!

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

  /// PATCH del profilo utente (aggiorna solo i campi passati).
  /// Usa UserProfileUpdate come modello di update,
  /// quindi puoi aggiornare city, bio, latitude, longitude, ecc.
  Future<bool> updateUserProfile(UserProfileUpdate update) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token') ?? '';

    if (token.isEmpty) {
      throw Exception('Utente non autenticato.');
    }

    final response = await http.patch(
      Uri.parse('$baseUrl/users/me'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(update.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Errore aggiornamento profilo: ${response.body}');
    }
  }

  /// Upload immagine profilo (POST multipart).
  /// Restituisce la URL pubblica dell’immagine caricata.
  Future<String> uploadProfileImage(File imageFile) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token') ?? '';

    if (token.isEmpty) {
      throw Exception('Utente non autenticato.');
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/users/me/upload-image'),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(
      await http.MultipartFile.fromPath('file', imageFile.path),
    );

    var response = await request.send();

    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      // Il backend ritorna direttamente la URL come stringa
      return respStr.replaceAll('"', ''); // pulisci eventuali apici
    } else {
      throw Exception('Errore upload immagine: ${response.reasonPhrase}');
    }
  }

  /// PATCH della posizione utente (solo city/lat/lon, per update manuale da profilo)
  /// Puoi chiamare solo updateUserProfile(UserProfileUpdate(...)) con i campi giusti.
  /// Esempio:
  ///   await updateUserProfile(UserProfileUpdate(
  ///     city: "Roma",
  ///     latitude: 41.9028,
  ///     longitude: 12.4964,
  ///   ));
}
