class UserDashboard {
  final String id; // UUID come stringa!
  final String username;
  final String email;
  final String city;
  final String? profileImage; // Campo per backend che manda profileImage
  final String? avatarUrl; // Compatibilità vecchie versioni
  final String? bio;
  final int xp;
  final int level;
  final int xpToNextLevel; // Nuovo campo, gestisce barra livello
  final int? eventsCreated; // Ora opzionale, se usi lista eventi invece che int
  final int? eventsJoined;
  final int? feedbackReceived;
  final double? latitude;
  final double? longitude;

  UserDashboard({
    required this.id,
    required this.username,
    required this.email,
    required this.city,
    this.profileImage,
    this.avatarUrl,
    this.bio,
    required this.xp,
    required this.level,
    required this.xpToNextLevel,
    this.eventsCreated,
    this.eventsJoined,
    this.feedbackReceived,
    this.latitude,
    this.longitude,
  });

  factory UserDashboard.fromJson(Map<String, dynamic> json) {
    return UserDashboard(
      id: json['id'].toString(),
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      city: json['city'] ?? '',
      profileImage: json['profileImage'],
      avatarUrl: json['avatarUrl'],
      bio: json['bio'],
      xp: json['xp'] ?? 0,
      level: json['level'] ?? 0,
      xpToNextLevel: json['xpToNextLevel'] ?? 0,
      eventsCreated: json['eventsCreated'], // Può essere int o null
      eventsJoined: json['eventsJoined'],
      feedbackReceived: json['feedbackReceived'],
      latitude: (json['latitude'] is num)
          ? (json['latitude'] as num).toDouble()
          : null,
      longitude: (json['longitude'] is num)
          ? (json['longitude'] as num).toDouble()
          : null,
    );
  }
}
