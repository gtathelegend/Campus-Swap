import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class PushNotificationsScreen extends StatefulWidget {
  const PushNotificationsScreen({super.key});

  @override
  State<PushNotificationsScreen> createState() => _PushNotificationsScreenState();
}

class _PushNotificationsScreenState extends State<PushNotificationsScreen> {
  bool _allNotifications = true;
  bool _messages = true;
  bool _listingActivity = true;
  bool _priceAlerts = true;
  bool _newListings = false;
  bool _reminders = true;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.base,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context)),
        title: Text('Push Notifications', style: Theme.of(context).textTheme.titleLarge),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Manage your notification preferences', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),

          Container(
            decoration: BoxDecoration(
              color: AppColors.base,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: _prefTile('All Notifications', 'Enable or disable all notifications', _allNotifications, _toggleAll),
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
                _prefTile('Messages', 'New messages and replies', _messages, (v) => setState(() => _messages = v)),
                const Divider(height: 1, indent: 16),
                _prefTile('Listing Activity', 'Views, favorites, and offers on your listings', _listingActivity, (v) => setState(() => _listingActivity = v)),
                const Divider(height: 1, indent: 16),
                _prefTile('Price Alerts', 'Price drops on items you\'re watching', _priceAlerts, (v) => setState(() => _priceAlerts = v)),
                const Divider(height: 1, indent: 16),
                _prefTile('New Listings', 'New items in your saved searches', _newListings, (v) => setState(() => _newListings = v)),
                const Divider(height: 1, indent: 16),
                _prefTile('Reminders', 'Listing reminders and follow-ups', _reminders, (v) => setState(() => _reminders = v), last: true),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notification preferences saved'), backgroundColor: AppColors.espresso),
                );
                Navigator.pop(context);
              },
              child: const Text('Save Preferences'),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _prefTile(String title, String subtitle, bool value, void Function(bool) onChanged, {bool last = false}) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.gold,
      title: Text(title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.espresso)),
      subtitle: Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: AppColors.stone)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
