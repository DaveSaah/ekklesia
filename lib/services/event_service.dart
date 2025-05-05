import 'dart:convert'; // For encoding/decoding JSON
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ekklesia/models/event.dart';

class EventService {
  final SupabaseClient _client = Supabase.instance.client;

  // Fetch the latest event
  Future<Event?> getLatestEvent() async {
    bool isOnline = await _isOnline(); // Check if connected to the internet

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

  // Check if the device is online or offline using internet_connection_checker
  Future<bool> _isOnline() async {
    final connectivityChecker = InternetConnectionChecker.createInstance();
    return await connectivityChecker.hasConnection;
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
}
