class Event {
  final String id;
  final String title;
  final String description;
  final DateTime eventDate;
  final bool eventCompleted;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.eventDate,
    required this.eventCompleted,
  });

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'].toString(),
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      eventDate: DateTime.parse(map['event_date']),
      eventCompleted: map['event_completed'] ?? false,
    );
  }

  // Convert the Event object to a map for saving into cache or database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'event_date': eventDate.toIso8601String(), // Convert DateTime to string
      'event_completed': eventCompleted,
    };
  }
}
