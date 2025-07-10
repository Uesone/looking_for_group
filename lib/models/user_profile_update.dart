/// Modello per update profilo utente.
/// Passa solo i campi che vuoi aggiornare!
/// Compatibile con PATCH /users/me lato backend.
/// (Latitudine e longitudine incluse per supporto geolocalizzazione.)
class UserProfileUpdate {
  final String? username;
  final String? city;
  final String? bio;
  final double? latitude; // <--- Campo GEO abilitato!
  final double? longitude; // <--- Campo GEO abilitato!

  UserProfileUpdate({
    this.username,
    this.city,
    this.bio,
    this.latitude,
    this.longitude,
  });

  /// Serializza solo i campi valorizzati!
  Map<String, dynamic> toJson() => {
    if (username != null) 'username': username,
    if (city != null) 'city': city,
    if (bio != null) 'bio': bio,
    if (latitude != null) 'latitude': latitude, // ora abilitato!
    if (longitude != null) 'longitude': longitude, // ora abilitato!
  };
}
