import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/preference_service.dart';
import '../theme/app_theme.dart';

class PushNotificationsScreen extends StatefulWidget {
  const PushNotificationsScreen({super.key});

  @override
  State<PushNotificationsScreen> createState() =>
      _PushNotificationsScreenState();
}

class _PushNotificationsScreenState extends State<PushNotificationsScreen> {
  final _prefService = PreferenceService();
  bool _loading = true;
  bool _saving = false;

  bool _allNotifications = true;
  bool _messages = true;
  bool _listingActivity = true;
  bool _priceAlerts = true;
  bool _newListings = false;
  bool _reminders = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final prefs = await _prefService.getPreferences();
      if (mounted) {
        setState(() {
          _messages = prefs['push_messages'] as bool? ?? true;
          _listingActivity = prefs['push_listing_activity'] as bool? ?? true;
          _priceAlerts = prefs['push_price_alerts'] as bool? ?? true;
          _newListings = prefs['push_new_listings'] as bool? ?? false;
          _reminders = prefs['push_reminders'] as bool? ?? true;
          _allNotifications =
              _messages && _listingActivity && _priceAlerts && _reminders;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _toggleAll(bool v) {
    setState(() {
      _allNotifications = v;
      _messages = v;
      _listingActivity = v;
      _priceAlerts = v;
      _newListings = v;
      _reminders = v;
    });
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await _prefService.savePreferences({
        'push_all': _allNotifications,
        'push_messages': _messages,
        'push_listing_activity': _listingActivity,
        'push_price_alerts': _priceAlerts,
        'push_new_listings': _newListings,
        'push_reminders': _reminders,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Notification preferences saved'),
            backgroundColor: AppColors.espresso));
        Navigator.pop(context);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Failed to save preferences'),
            backgroundColor: AppColors.alert));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.base,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () => Navigator.pop(context)),
        title: Text('Push Notifications',
            style: Theme.of(context).textTheme.titleLarge),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.gold))
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text('Manage your notification preferences',
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.base,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: _prefTile('All Notifications',
                      'Enable or disable all notifications',
                      _allNotifications, _toggleAll),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.base,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      _prefTile('Messages', 'New messages and replies',
                          _messages, (v) => setState(() => _messages = v)),
                      const Divider(height: 1, indent: 16),
                      _prefTile(
                          'Listing Activity',
                          'Views, favorites, and offers on your listings',
                          _listingActivity,
                          (v) => setState(() => _listingActivity = v)),
                      const Divider(height: 1, indent: 16),
                      _prefTile(
                          'Price Alerts',
                          'Price drops on items you\'re watching',
                          _priceAlerts,
                          (v) => setState(() => _priceAlerts = v)),
                      const Divider(height: 1, indent: 16),
                      _prefTile(
                          'New Listings',
                          'New items in your saved searches',
                          _newListings,
                          (v) => setState(() => _newListings = v)),
                      const Divider(height: 1, indent: 16),
                      _prefTile(
                          'Reminders',
                          'Listing reminders and follow-ups',
                          _reminders,
                          (v) => setState(() => _reminders = v)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saving ? null : _save,
                    child: _saving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : const Text('Save Preferences'),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
    );
  }

  Widget _prefTile(String title, String subtitle, bool value,
      void Function(bool) onChanged) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.gold,
      title: Text(title,
          style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.espresso)),
      subtitle: Text(subtitle,
          style: GoogleFonts.inter(fontSize: 12, color: AppColors.stone)),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
