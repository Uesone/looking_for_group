class UserProfileUpdate {
  final String? username;
  final String? city;
  final String? bio;
  final double? latitude;
  final double? longitude;

  UserProfileUpdate({
    this.username,
    this.city,
    this.bio,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toJson() => {
    if (username != null) 'username': username,
    if (city != null) 'city': city,
    if (bio != null) 'bio': bio,
    //if (latitude != null) 'latitude': latitude,
    //if (longitude != null) 'longitude': longitude, ----- da aggiungere in futuro per geolocalizzazione.
  };
}
