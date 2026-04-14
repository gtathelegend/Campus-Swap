import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class EmailPreferencesScreen extends StatefulWidget {
  const EmailPreferencesScreen({super.key});

  @override
  State<EmailPreferencesScreen> createState() => _EmailPreferencesScreenState();
}

class _EmailPreferencesScreenState extends State<EmailPreferencesScreen> {
  bool _newMessages = true;
  bool _itemUpdates = true;
  bool _priceDrops = false;
  bool _marketingEmails = false;
  bool _weeklySummary = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.base,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context)),
        title: Text('Email Preferences', style: Theme.of(context).textTheme.titleLarge),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Choose what emails you receive', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: AppColors.base,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                _prefTile('New Messages', 'Get notified when you receive a new message', _newMessages, (v) => setState(() => _newMessages = v)),
                const Divider(height: 1, indent: 16),
                _prefTile('Item Updates', "Updates on items you're interested in", _itemUpdates, (v) => setState(() => _itemUpdates = v)),
                const Divider(height: 1, indent: 16),
                _prefTile('Price Drops', 'Notifications when prices drop on saved items', _priceDrops, (v) => setState(() => _priceDrops = v)),
                const Divider(height: 1, indent: 16),
                _prefTile('Marketing Emails', 'Tips, promotions, and Campus Swap news', _marketingEmails, (v) => setState(() => _marketingEmails = v)),
                const Divider(height: 1, indent: 16),
                _prefTile('Weekly Summary', 'Weekly digest of your activity', _weeklySummary, (v) => setState(() => _weeklySummary = v), last: true),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Preferences saved'), backgroundColor: AppColors.espresso),
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
