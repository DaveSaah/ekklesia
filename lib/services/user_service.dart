import 'package:ekklesia/services/connection_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  final _client = Supabase.instance.client;

  Future<String> getUuid() async {
    return _client.auth.currentUser!.id;
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  Future<String> getDisplayName() async {
    bool online =
        await ConnectionService()
            .isOnline(); // Check if connected to the internet

    if (!online) {
      // load from cache
      final displayName = await _getNameFromCache();
      if (displayName != null) {
        return displayName;
      }
    }

    final String userId = await getUuid();

    final response =
        await _client
            .from('profiles')
            .select('display_name')
            .eq('id', userId)
            .single();

    _cacheName(response['display_name']);

    return response['display_name'];
  }

  // Cache display name
  Future<void> _cacheName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('display_name', name);
  }
}

// Fetch the cached name from shared preferences
Future<String?> _getNameFromCache() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('display_name');
}
