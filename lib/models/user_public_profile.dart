class UserPublicProfile {
  // NOTA: id non è più presente in DTO backend per profilo pubblico!
  final String username;
  final String city;
  final String?
  profileImage; // nuovo campo corretto (avatarUrl era vecchio/nullo)
  final String? bio;
  final int level;
  final double? latitude;
  final double? longitude;

  UserPublicProfile({
    required this.username,
    required this.city,
    this.profileImage,
    this.bio,
    required this.level,
    this.latitude,
    this.longitude,
  });

  factory UserPublicProfile.fromJson(Map<String, dynamic> json) {
    return UserPublicProfile(
      username: json['username'] ?? '',
      city: json['city'] ?? '',
      profileImage: json['profileImage'],
      bio: json['bio'],
      level: json['level'] ?? 0,
      latitude: (json['latitude'] is num)
          ? (json['latitude'] as num).toDouble()
          : null,
      longitude: (json['longitude'] is num)
          ? (json['longitude'] as num).toDouble()
          : null,
    );
  }
}
