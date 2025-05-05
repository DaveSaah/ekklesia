import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ekklesia/models/event.dart';

class EventService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<Event?> getLatestEvent() async {
    try {
      final response = await _client.rpc('get_latest_event').maybeSingle();
      if (response == null) {
        return null;
      }

      return Event.fromMap(response);
    } catch (e) {
      print('Error fetching latest event: $e');
      return null;
    }
  }
}
