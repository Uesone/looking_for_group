import 'package:geolocator/geolocator.dart';

/// Restituisce la posizione attuale dell’utente (GPS).
/// Lancia eccezione se i servizi sono disattivati o i permessi negati.
/// Da usare con `await getCurrentPosition();`
///
/// Esempio d’uso:
/// ```dart
/// try {
///   final position = await getCurrentPosition();
///   print('${position.latitude}, ${position.longitude}');
/// } catch (e) {
///   print('Errore posizione: $e');
/// }
/// ```
Future<Position> getCurrentPosition() async {
  // Controlla se i servizi di localizzazione sono attivi
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw Exception('I servizi di localizzazione sono disattivati.');
  }

  // Controlla i permessi
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('Permesso posizione negato.');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw Exception(
      'Permesso posizione negato in modo permanente. Modifica le impostazioni.',
    );
  }

  // Restituisce la posizione
  return await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
}
