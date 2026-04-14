import 'package:supabase_flutter/supabase_flutter.dart';

/// Persists user notification and email preferences to Supabase.
class PreferenceService {
  final _client = Supabase.instance.client;
  String? get _uid => _client.auth.currentUser?.id;

  Future<Map<String, dynamic>> getPreferences() async {
    if (_uid == null) return _defaults();
    final data = await _client
        .from('user_preferences')
        .select()
        .eq('user_id', _uid!)
        .maybeSingle();
    if (data == null) return _defaults();
    final merged = Map<String, dynamic>.from(_defaults());
    merged.addAll(data);
    return merged;
  }

  Future<void> savePreferences(Map<String, dynamic> prefs) async {
    if (_uid == null) return;
    await _client.from('user_preferences').upsert({
      'user_id': _uid,
      ...prefs,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  Map<String, dynamic> _defaults() => {
        'push_all': true,
        'push_messages': true,
        'push_listing_activity': true,
        'push_price_alerts': true,
        'push_new_listings': false,
        'push_reminders': true,
        'email_new_messages': true,
        'email_item_updates': true,
        'email_price_drops': false,
        'email_marketing': false,
        'email_weekly_summary': true,
        'chat_notifications': true,
        'chat_show_preview': true,
        'chat_sound': true,
        'chat_vibrate': true,
        'chat_dnd': false,
        'chat_dnd_from': '22:00',
        'chat_dnd_to': '07:00',
      };
}
