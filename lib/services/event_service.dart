import 'dart:convert'; // For encoding/decoding JSON
import 'package:ekklesia/services/connection_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ekklesia/models/event.dart';

class EventService {
  final SupabaseClient _client = Supabase.instance.client;

  // Fetch the latest event
  Future<Event?> getLatestEvent() async {
    bool isOnline =
        await ConnectionService()
            .isOnline(); // Check if connected to the internet

    if (!isOnline) {
      // If offline, fetch event from cache
      final eventFromCache = await _getEventFromCache();
      if (eventFromCache != null) {
        return eventFromCache;
      }
    }

    // If online, fetch event from network
    try {
      final response = await _client.rpc('get_latest_event').maybeSingle();
      if (response == null) {
        return null;
      }

      // Convert response to Event model
      final event = Event.fromMap(response);

      // Cache the event data for offline use
      await _cacheEvent(event);

      return event;
    } catch (e) {
      print('Error fetching latest event: $e');
      return null;
    }
  }

  // Cache the event data
  Future<void> _cacheEvent(Event event) async {
    final prefs = await SharedPreferences.getInstance();
    final eventJson = json.encode(
      event.toMap(),
    ); // Convert event to JSON string
    await prefs.setString('latest_event', eventJson);
  }

  // Fetch the cached event from shared preferences
  Future<Event?> _getEventFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final eventJson = prefs.getString('latest_event');

    if (eventJson != null) {
      final eventMap = json.decode(eventJson);
      return Event.fromMap(eventMap);
    }

    return null;
  }

  // Register user for an event
  Future<void> registerForEvent(String attendantId, int eventId) async {
    try {
      final response = await _client
          .from('event_attendees') // The table name
          .insert([
            {'attendant_id': attendantId, 'event_id': eventId},
          ]);

      if (response.error != null) {
        throw Exception(
          'Error registering for event: ${response.error!.message}',
        );
      }

      print("Successfully registered for the event");
    } catch (e) {
      print('Error during registration: $e');
    }
  }

  // Check if the user is already registered for the event using the Supabase function
  Future<bool> isUserRegisteredForEvent(String attendantId, int eventId) async {
    try {
      final response =
          await _client
              .rpc(
                'is_user_registered_for_event',
                params: {'attendant_id': attendantId, 'event_id': eventId},
              )
              .maybeSingle();

      final isRegistered = response?['registered'] as bool;
      return isRegistered;
    } catch (e) {
      print('Error during check: $e');
      throw Exception('Failed to check registration status');
    }
  }
}
