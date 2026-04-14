import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class ChatNotificationsScreen extends StatefulWidget {
  const ChatNotificationsScreen({super.key});

  @override
  State<ChatNotificationsScreen> createState() => _ChatNotificationsScreenState();
}

class _ChatNotificationsScreenState extends State<ChatNotificationsScreen> {
  bool _messageNotifications = true;
  bool _showPreview = true;
  bool _sound = true;
  bool _vibrate = true;
  bool _doNotDisturb = false;
  TimeOfDay _fromTime = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _toTime = const TimeOfDay(hour: 7, minute: 0);

  String _formatTime(TimeOfDay t) {
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final m = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$m $period';
  }

  Future<void> _pickTime(bool isFrom) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isFrom ? _fromTime : _toTime,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.gold),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => isFrom ? _fromTime = picked : _toTime = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.base,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context)),
        title: Text('Chat Notifications', style: Theme.of(context).textTheme.titleLarge),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Control how you\'re notified about messages', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),

          Container(
            decoration: BoxDecoration(
              color: AppColors.base,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                _switchTile('Message Notifications', 'Enable message notifications', _messageNotifications, (v) => setState(() => _messageNotifications = v)),
                const Divider(height: 1, indent: 16),
                _switchTile('Show Preview', 'Show message content in notifications', _showPreview, (v) => setState(() => _showPreview = v)),
                const Divider(height: 1, indent: 16),
                _switchTile('Sound', 'Sound for new messages', _sound, (v) => setState(() => _sound = v)),
                const Divider(height: 1, indent: 16),
                _switchTile('Vibrate', 'Vibrate for new messages', _vibrate, (v) => setState(() => _vibrate = v), last: true),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Do Not Disturb
          Container(
            decoration: BoxDecoration(
              color: AppColors.base,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                _switchTile('Do Not Disturb', 'Silence notifications during set hours', _doNotDisturb, (v) => setState(() => _doNotDisturb = v)),
                if (_doNotDisturb) ...[
                  const Divider(height: 1, indent: 16),
                  _timeTile('From', _formatTime(_fromTime), () => _pickTime(true)),
                  const Divider(height: 1, indent: 16),
                  _timeTile('To', _formatTime(_toTime), () => _pickTime(false), last: true),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Chat notification settings saved'), backgroundColor: AppColors.espresso),
                );
                Navigator.pop(context);
              },
              child: const Text('Save Settings'),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _switchTile(String title, String subtitle, bool value, void Function(bool) onChanged, {bool last = false}) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.gold,
      title: Text(title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.espresso)),
      subtitle: Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: AppColors.stone)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  Widget _timeTile(String label, String time, VoidCallback onTap, {bool last = false}) {
    return ListTile(
      title: Text(label, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.espresso)),
      trailing: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.cream,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(time, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.espresso)),
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
