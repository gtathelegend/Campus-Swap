import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/preference_service.dart';
import '../theme/app_theme.dart';
import '../widgets/brand_title.dart';

class ChatNotificationsScreen extends StatefulWidget {
  const ChatNotificationsScreen({super.key});

  @override
  State<ChatNotificationsScreen> createState() =>
      _ChatNotificationsScreenState();
}

class _ChatNotificationsScreenState extends State<ChatNotificationsScreen> {
  final _prefService = PreferenceService();
  bool _loading = true;
  bool _saving = false;

  bool _messageNotifications = true;
  bool _showPreview = true;
  bool _sound = true;
  bool _vibrate = true;
  bool _doNotDisturb = false;
  TimeOfDay _fromTime = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _toTime = const TimeOfDay(hour: 7, minute: 0);

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
          _messageNotifications = prefs['chat_notifications'] as bool? ?? true;
          _showPreview = prefs['chat_show_preview'] as bool? ?? true;
          _sound = prefs['chat_sound'] as bool? ?? true;
          _vibrate = prefs['chat_vibrate'] as bool? ?? true;
          _doNotDisturb = prefs['chat_dnd'] as bool? ?? false;
          final fromStr = prefs['chat_dnd_from'] as String? ?? '22:00';
          final toStr = prefs['chat_dnd_to'] as String? ?? '07:00';
          _fromTime = _parseTime(fromStr);
          _toTime = _parseTime(toStr);
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  TimeOfDay _parseTime(String s) {
    final parts = s.split(':');
    return TimeOfDay(
        hour: int.tryParse(parts[0]) ?? 22,
        minute: int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0);
  }

  String _serializeTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

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
          colorScheme:
              const ColorScheme.light(primary: AppColors.gold),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => isFrom ? _fromTime = picked : _toTime = picked);
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await _prefService.savePreferences({
        'chat_notifications': _messageNotifications,
        'chat_show_preview': _showPreview,
        'chat_sound': _sound,
        'chat_vibrate': _vibrate,
        'chat_dnd': _doNotDisturb,
        'chat_dnd_from': _serializeTime(_fromTime),
        'chat_dnd_to': _serializeTime(_toTime),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Chat notification settings saved'),
            backgroundColor: AppColors.espresso));
        Navigator.pop(context);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Failed to save settings'),
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
        title: const BrandTitle('Chat Notifications'),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.gold))
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text('Control how you\'re notified about messages',
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.base,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      _switchTile(
                          'Message Notifications',
                          'Enable message notifications',
                          _messageNotifications,
                          (v) =>
                              setState(() => _messageNotifications = v)),
                      const Divider(height: 1, indent: 16),
                      _switchTile(
                          'Show Preview',
                          'Show message content in notifications',
                          _showPreview,
                          (v) => setState(() => _showPreview = v)),
                      const Divider(height: 1, indent: 16),
                      _switchTile('Sound', 'Sound for new messages', _sound,
                          (v) => setState(() => _sound = v)),
                      const Divider(height: 1, indent: 16),
                      _switchTile('Vibrate', 'Vibrate for new messages',
                          _vibrate, (v) => setState(() => _vibrate = v)),
                    ],
                  ),
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
                      _switchTile(
                          'Do Not Disturb',
                          'Silence notifications during set hours',
                          _doNotDisturb,
                          (v) => setState(() => _doNotDisturb = v)),
                      if (_doNotDisturb) ...[
                        const Divider(height: 1, indent: 16),
                        _timeTile('From', _formatTime(_fromTime),
                            () => _pickTime(true)),
                        const Divider(height: 1, indent: 16),
                        _timeTile(
                            'To', _formatTime(_toTime), () => _pickTime(false)),
                      ],
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
                        : const Text('Save Settings'),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
    );
  }

  Widget _switchTile(String title, String subtitle, bool value,
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

  Widget _timeTile(String label, String time, VoidCallback onTap) {
    return ListTile(
      title: Text(label,
          style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.espresso)),
      trailing: GestureDetector(
        onTap: onTap,
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.cream,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(time,
              style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.espresso)),
        ),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
