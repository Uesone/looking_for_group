// lib/services/location_permission_service.dart

import 'package:permission_handler/permission_handler.dart';

/// Service centralizzato per la richiesta e il controllo dei permessi di localizzazione.
/// Usa [permission_handler], compatibile Android/iOS e tutte le versioni recenti.
class LocationPermissionService {
  /// Richiede il permesso di localizzazione all’utente.
  /// Ritorna true se concesso, false se negato.
  static Future<bool> requestLocationPermission() async {
    // Se già concesso, ritorna subito true.
    if (await Permission.locationWhenInUse.isGranted) return true;

    // Se negato, mostra dialogo di sistema per la richiesta.
    final status = await Permission.locationWhenInUse.request();

    // Su iOS 14+ e Android 11+ può essere 'limited' (autorizzato solo a foreground/location approssimativa)
    return status == PermissionStatus.granted ||
        status == PermissionStatus.limited;
  }

  /// Controlla se il permesso posizione è almeno 'limited' (Android 11+/iOS 14+)
  static Future<bool> hasLocationPermission() async {
    final status = await Permission.locationWhenInUse.status;
    return status == PermissionStatus.granted ||
        status == PermissionStatus.limited;
  }

  /// True se il permesso è stato negato per sempre ("never ask again").
  static Future<bool> isDeniedForever() async {
    final status = await Permission.locationWhenInUse.status;
    return status == PermissionStatus.permanentlyDenied;
  }

  /// Mostra un dialogo alle impostazioni, utile in caso di deniedForever.
  static Future<void> openSettings() async {
    await openAppSettings();
  }
}
