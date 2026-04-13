import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: Text('Profile', style: Theme.of(context).textTheme.titleLarge),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.15), shape: BoxShape.circle),
                  child: const Center(child: Text('👤', style: TextStyle(fontSize: 36))),
                ),
                const SizedBox(height: 12),
                Text('Alex Johnson', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 4),
                Text('alex.johnson@university.edu', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, size: 14, color: AppColors.gold),
                    const SizedBox(width: 4),
                    Text('4.7 · 8 reviews', style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.verified, size: 12, color: AppColors.gold),
                          const SizedBox(width: 4),
                          Text('Verified Student', style: GoogleFonts.inter(fontSize: 11, color: AppColors.gold, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.base,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _stat(context, '5', 'Listings'),
                Container(width: 1, height: 40, color: AppColors.border),
                _stat(context, '3', 'Sold'),
                Container(width: 1, height: 40, color: AppColors.border),
                _stat(context, '8', 'Reviews'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              color: AppColors.base,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                _menuItem(context, Icons.list_alt_outlined, 'My Listings', () {}),
                const Divider(height: 1, indent: 56),
                _menuItem(context, Icons.bookmark_outline, 'Saved Items', () {}),
                const Divider(height: 1, indent: 56),
                _menuItem(context, Icons.settings_outlined, 'Settings', () {}),
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
            child: _menuItem(
              context,
              Icons.logout,
              'Log Out',
              () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (_) => false,
                );
              },
              color: AppColors.alert,
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _stat(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.espresso)),
        const SizedBox(height: 2),
        Text(label, style: GoogleFonts.inter(fontSize: 12, color: AppColors.stone)),
      ],
    );
  }

  Widget _menuItem(BuildContext context, IconData icon, String label, VoidCallback onTap, {Color? color}) {
    final c = color ?? AppColors.espresso;
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(color: c.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: c, size: 18),
      ),
      title: Text(label, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: c)),
      trailing: color == null ? const Icon(Icons.chevron_right, color: AppColors.stone, size: 20) : null,
      onTap: onTap,
    );
  }
}
