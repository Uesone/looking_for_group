/// Modello per eventi nel feed.
/// Mostra SOLO la città nel feed.
/// La distanza dall’utente è opzionale, presente solo se geo attiva.
class EventFeed {
  final String id;
  final String title;
  final String activityType;
  final String? city;
  final DateTime date;
  final int maxParticipants;
  final String creatorId;
  final String creatorUsername;
  final int creatorLevel;
  final double? distanceFromUser;

  EventFeed({
    required this.id,
    required this.title,
    required this.activityType,
    this.city,
    required this.date,
    required this.maxParticipants,
    required this.creatorId,
    required this.creatorUsername,
    required this.creatorLevel,
    this.distanceFromUser,
  });

  factory EventFeed.fromJson(Map<String, dynamic> json) {
    return EventFeed(
      id: json['id'].toString(),
      title: json['title'] ?? 'Titolo sconosciuto',
      activityType: json['activityType'] ?? 'Attività',
      city: json['city'],
      date: DateTime.parse(json['date']),
      maxParticipants: json['maxParticipants'] ?? 1,
      creatorId: (json['creatorId'] ?? '').toString(),
      creatorUsername: json['creatorUsername'] ?? 'Sconosciuto',
      creatorLevel: json['creatorLevel'] ?? 1,
      distanceFromUser: json['distanceFromUser'] != null
          ? (json['distanceFromUser'] as num).toDouble()
          : null,
    );
  }
}
