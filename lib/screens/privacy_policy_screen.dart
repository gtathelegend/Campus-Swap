import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.base,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context)),
        title: Text('Privacy Policy', style: Theme.of(context).textTheme.titleLarge),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Last Updated: December 5, 2024', style: GoogleFonts.inter(fontSize: 12, color: AppColors.stone)),
          const SizedBox(height: 20),
          ..._sections.map((s) => _buildSection(context, s.$1, s.$2)),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.espresso)),
          const SizedBox(height: 8),
          Text(body, style: GoogleFonts.inter(fontSize: 14, color: AppColors.mocha, height: 1.6)),
        ],
      ),
    );
  }

  static const _sections = [
    ('1. Information We Collect',
      'We collect information you provide directly to us, such as when you create an account, post a listing, or contact support. This includes your name, email address, university email, and any content you post on Campus Swap. We also collect information automatically when you use our services, including usage data, device information, and log files.'),
    ('2. How We Use Your Information',
      'We use the information we collect to provide, maintain, and improve our services, to understand how our users interact with Campus Swap, to facilitate transactions between buyers and sellers, and to communicate with you about your account and listings. We do not sell your personal information to third parties.'),
    ('3. Information Sharing',
      'We do not share your personal information with third parties except as described in this policy. We may share information with service providers who help us operate our platform, when required by law, or to protect the rights and safety of our users and the public.'),
    ('4. Data Security',
      'We implement appropriate technical and organizational measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction. However, no internet transmission is completely secure, and we cannot guarantee absolute security.'),
    ('5. Your Rights',
      'You have the right to access, update, or delete the information we hold about you. You can do this through your account settings at any time. You may also request a copy of your data or opt out of certain data processing activities by contacting us.'),
    ('6. Contact Us',
      'If you have any questions about this Privacy Policy or our data practices, please contact our support team through the Help Center in the app settings.'),
  ];
}
