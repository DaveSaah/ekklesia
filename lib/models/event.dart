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
}
