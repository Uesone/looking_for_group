class UserDashboard {
  final String id; // UUID come stringa!
  final String username;
  final String email;
  final String city;
  final String? profileImage;
  final String? avatarUrl;
  final String? bio;
  final int xp;
  final int level;
  final int xpToNextLevel;
  final int? eventsCreated;
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

  // AGGIUNTO: copyWith per aggiornare solo i campi modificati
  UserDashboard copyWith({
    String? username,
    String? city,
    String? bio,
    String? profileImage,
    String? avatarUrl,
    int? xp,
    int? level,
    int? xpToNextLevel,
    int? eventsCreated,
    int? eventsJoined,
    int? feedbackReceived,
    double? latitude,
    double? longitude,
  }) {
    return UserDashboard(
      id: id,
      username: username ?? this.username,
      email: email,
      city: city ?? this.city,
      profileImage: profileImage ?? this.profileImage,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      xpToNextLevel: xpToNextLevel ?? this.xpToNextLevel,
      eventsCreated: eventsCreated ?? this.eventsCreated,
      eventsJoined: eventsJoined ?? this.eventsJoined,
      feedbackReceived: feedbackReceived ?? this.feedbackReceived,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

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
      eventsCreated: json['eventsCreated'],
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
