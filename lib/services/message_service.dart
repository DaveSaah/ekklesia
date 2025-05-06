import 'dart:convert';
import 'package:ekklesia/models/message.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ekklesia/services/connection_service.dart';

class MessageService {
  final SupabaseClient _client = Supabase.instance.client;
  final String _table = 'messages';

  // Send a message
  Future<void> sendMessage(Message message) async {
    bool isOnline = await ConnectionService().isOnline();

    if (isOnline) {
      try {
        await _client.from(_table).insert(message.toMap());
      } catch (e) {
        print('Error sending message: $e');
        await _queueMessage(message);
      }
    } else {
      // If offline, add to queue
      await _queueMessage(message);
    }
  }

  // Fetch messages for a specific event, with offline fallback
  Future<List<Message>> fetchMessages(int eventId) async {
    bool isOnline = await ConnectionService().isOnline();

    if (!isOnline) {
      final messagesFromCache = await _getMessagesFromCache(eventId);
      if (messagesFromCache.isNotEmpty) {
        return messagesFromCache;
      }
    }

    try {
      final messages = await _client
          .from(_table)
          .select()
          .eq('event_id', eventId)
          .order('created_at', ascending: true)
          .withConverter((messages) => messages.map(Message.fromMap).toList());

      if (messages.isEmpty) {
        return [];
      }

      await _cacheMessages(eventId, messages);

      return messages;
    } catch (e) {
      print('Error fetching messages: $e');
      return [];
    }
  }

  // Real-time stream for new messages on a specific event
  Stream<List<Message>> subscribeToMessages(String eventId) {
    return _client
        .from(_table)
        .stream(primaryKey: ['id'])
        .eq('event_id', eventId)
        .order('created_at', ascending: true)
        .map((data) => data.map((item) => Message.fromMap(item)).toList());
  }

  // Cache messages for an event
  Future<void> _cacheMessages(int eventId, List<Message> messages) async {
    final prefs = await SharedPreferences.getInstance();
    final messagesJson = json.encode(messages.map((m) => m.toMap()).toList());
    await prefs.setString('messages_$eventId', messagesJson);
  }

  // Fetch cached messages for an event
  Future<List<Message>> _getMessagesFromCache(int eventId) async {
    final prefs = await SharedPreferences.getInstance();
    final messagesJson = prefs.getString('messages_$eventId');

    if (messagesJson != null) {
      final messagesMapList = List<Map<String, dynamic>>.from(
        json.decode(messagesJson),
      );
      return messagesMapList
          .map((messageMap) => Message.fromMap(messageMap))
          .toList();
    }

    return [];
  }

  // Queue message for later sending
  Future<void> _queueMessage(Message message) async {
    final prefs = await SharedPreferences.getInstance();
    final existingQueueJson = prefs.getString('message_queue');
    List<Map<String, dynamic>> queue = [];

    if (existingQueueJson != null) {
      queue = List<Map<String, dynamic>>.from(json.decode(existingQueueJson));
    }

    queue.add(message.toMap());
    await prefs.setString('message_queue', json.encode(queue));

    print('Message queued for later sending.');
  }

  // Send all queued messages when online
  Future<void> sendQueuedMessages() async {
    bool isOnline = await ConnectionService().isOnline();
    if (!isOnline) return;

    final prefs = await SharedPreferences.getInstance();
    final queueJson = prefs.getString('message_queue');

    if (queueJson != null) {
      List<Map<String, dynamic>> queue = List<Map<String, dynamic>>.from(
        json.decode(queueJson),
      );

      for (var messageMap in queue) {
        final message = Message.fromMap(messageMap);
        try {
          final response = await _client.from(_table).insert(message.toMap());
          if (response.error == null) {
            print('Queued message sent.');
          }
        } catch (e) {
          print('Error sending queued message: $e');
        }
      }

      // Clear the queue after attempting to send
      await prefs.remove('message_queue');
    }
  }
}
