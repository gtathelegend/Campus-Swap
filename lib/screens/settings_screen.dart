import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'edit_profile_screen.dart';
import 'change_password_screen.dart';
import 'email_preferences_screen.dart';
import 'push_notifications_screen.dart';
import 'chat_notifications_screen.dart';
import 'blocked_users_screen.dart';
import 'privacy_policy_screen.dart';
import 'terms_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.base,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context)),
        title: Text('Settings', style: Theme.of(context).textTheme.titleLarge),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _sectionHeader('ACCOUNT'),
          _settingsGroup([
            _settingsItem(context, Icons.person_outline, 'Edit Profile',
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen()))),
            _settingsItem(context, Icons.lock_outline, 'Change Password',
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChangePasswordScreen()))),
            _settingsItem(context, Icons.email_outlined, 'Email Preferences',
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EmailPreferencesScreen())),
                last: true),
          ]),
          const SizedBox(height: 20),

          _sectionHeader('NOTIFICATIONS'),
          _settingsGroup([
            _settingsItem(context, Icons.notifications_outlined, 'Push Notifications',
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PushNotificationsScreen()))),
            _settingsItem(context, Icons.chat_outlined, 'Chat Notifications',
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatNotificationsScreen())),
                last: true),
          ]),
          const SizedBox(height: 20),

          _sectionHeader('PRIVACY & SAFETY'),
          _settingsGroup([
            _settingsItem(context, Icons.block, 'Blocked Users',
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BlockedUsersScreen()))),
            _settingsItem(context, Icons.privacy_tip_outlined, 'Privacy Policy',
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()))),
            _settingsItem(context, Icons.description_outlined, 'Terms of Service',
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TermsScreen())),
                last: true),
          ]),
          const SizedBox(height: 20),

          _sectionHeader('ABOUT'),
          _settingsGroup([
            _settingsItem(context, Icons.help_outline, 'Help Center', () {}, last: true),
          ]),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _sectionHeader(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(text, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.stone, letterSpacing: 0.8)),
    );
  }

  Widget _settingsGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.base,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: children),
    );
  }

  Widget _settingsItem(BuildContext context, IconData icon, String label, VoidCallback onTap, {bool last = false}) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: AppColors.espresso.withOpacity(0.08), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: AppColors.espresso, size: 18),
          ),
          title: Text(label, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.espresso)),
          trailing: const Icon(Icons.chevron_right, color: AppColors.stone, size: 20),
          onTap: onTap,
        ),
        if (!last) const Divider(height: 1, indent: 56),
      ],
    );
  }
}
