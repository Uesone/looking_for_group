class EventFeed {
  final String id;
  final String title;
  final String activityType;
  final String location;
  final DateTime date;
  final int maxParticipants;
  final String creatorId;
  final String creatorUsername;
  final int creatorLevel;

  EventFeed({
    required this.id,
    required this.title,
    required this.activityType,
    required this.location,
    required this.date,
    required this.maxParticipants,
    required this.creatorId,
    required this.creatorUsername,
    required this.creatorLevel,
  });

  // Factory per costruire l'oggetto dal JSON
  factory EventFeed.fromJson(Map<String, dynamic> json) {
    return EventFeed(
      id: json['id'],
      title: json['title'],
      activityType: json['activityType'],
      location: json['location'],
      date: DateTime.parse(json['date']),
      maxParticipants: json['maxParticipants'],
      creatorId: json['creatorId'],
      creatorUsername: json['creatorUsername'],
      creatorLevel: json['creatorLevel'],
    );
  }
}
