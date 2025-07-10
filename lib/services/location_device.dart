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
  // 1. Controlla se i servizi di localizzazione sono attivi
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw Exception(
      'I servizi di localizzazione sono disattivati. Attivali nelle impostazioni.',
    );
  }

  // 2. Controlla i permessi
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception(
        'Permesso posizione negato. Consenti la posizione per usare questa funzione.',
      );
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw Exception(
      'Permesso posizione negato in modo permanente. Vai nelle impostazioni per abilitare la localizzazione.',
    );
  }

  // 3. Restituisce la posizione con alta precisione
  try {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  } catch (e) {
    throw Exception('Impossibile ottenere la posizione: $e');
  }
}
