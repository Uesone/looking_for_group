class EventFeed {
  final String id;
  final String creatorID;
  final String title;
  final String activityType;
  final String location;
  final String? city;
  final String? notes;
  final DateTime date;
  final int maxParticipants;
  final String joinMode;
  final String creatorUsername;
  final int creatorLevel;

  EventFeed({
    required this.id,
    required this.creatorID,
    required this.title,
    required this.activityType,
    required this.location,
    this.city,
    this.notes,
    required this.date,
    required this.maxParticipants,
    required this.joinMode,
    required this.creatorUsername,
    required this.creatorLevel,
  });

  factory EventFeed.fromJson(Map<String, dynamic> json) {
    return EventFeed(
      id: json['id'].toString(),
      creatorID: (json['creatorID'] ?? json['creatorId'] ?? '').toString(),
      title: json['title'] ?? 'Titolo sconosciuto',
      activityType: json['activityType'] ?? 'Attività',
      location: json['location'] ?? json['city'] ?? 'Luogo non definito',
      city: json['city'],
      notes: json['notes'],
      date: DateTime.parse(json['date']),
      maxParticipants: json['maxParticipants'] ?? 1,
      joinMode: json['joinMode'] ?? 'AUTO',
      creatorUsername: json['creatorUsername'] ?? 'Sconosciuto',
      creatorLevel: json['creatorLevel'] ?? 1,
    );
  }
}
