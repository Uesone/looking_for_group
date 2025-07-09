// lib/services/location_permission_service.dart

import 'package:permission_handler/permission_handler.dart';

class LocationPermissionService {
  // Richiede permesso posizione e ritorna true se concesso, false altrimenti
  static Future<bool> requestLocationPermission() async {
    // Se già concesso, ritorna true subito
    if (await Permission.locationWhenInUse.isGranted) return true;

    // Se negato, mostra dialogo di sistema per la richiesta
    final status = await Permission.locationWhenInUse.request();
    return status == PermissionStatus.granted;
  }

  // True se almeno "limitato" (per le nuove policy Android/iOS)
  static Future<bool> hasLocationPermission() async {
    final status = await Permission.locationWhenInUse.status;
    return status == PermissionStatus.granted ||
        status == PermissionStatus.limited;
  }
}
