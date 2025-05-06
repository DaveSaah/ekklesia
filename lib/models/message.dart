class Message {
  int? id;
  final String senderId;
  final int eventId;
  final String? messageText;
  final String? mediaUrl;
  final String? mediaType; // "image", "audio"
  final DateTime createdAt;

  Message({
    this.id,
    required this.senderId,
    required this.eventId,
    this.messageText,
    this.mediaUrl,
    this.mediaType,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'sender_id': senderId,
      'event_id': eventId,
      'message_text': messageText,
      'media_url': mediaUrl,
      'media_type': mediaType,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
      senderId: map['sender_id'],
      eventId: map['event_id'],
      messageText: map['message_text'],
      mediaUrl: map['media_url'],
      mediaType: map['media_type'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
