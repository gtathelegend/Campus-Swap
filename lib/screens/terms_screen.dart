import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.base,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context)),
        title: Text('Terms of Service', style: Theme.of(context).textTheme.titleLarge),
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
    ('1. Acceptance of Terms',
      'By accessing and using Campus Swap, you accept and agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use our platform. We reserve the right to modify these terms at any time, and continued use constitutes acceptance of any changes.'),
    ('2. Eligibility',
      'Campus Swap is intended for use by currently enrolled students at recognized universities. You must be at least 18 years old and have a valid university email address to create an account. By using Campus Swap, you represent that you meet these requirements.'),
    ('3. User Conduct',
      'You agree to use Campus Swap only for lawful purposes and in accordance with these Terms. You will not post false or misleading information, engage in fraudulent transactions, harass other users, or attempt to circumvent Campus Swap\'s safety features.'),
    ('4. Listings and Transactions',
      'You are solely responsible for the accuracy of your listings and all transactions you engage in. Campus Swap is a platform facilitating peer-to-peer transactions and is not a party to any transaction. We encourage all users to meet in safe, public campus locations.'),
    ('5. Content Ownership',
      'You retain ownership of the content you post on Campus Swap, but grant us a non-exclusive license to use, display, and distribute your content as needed to operate the platform. You are responsible for ensuring you have the right to post any content you upload.'),
    ('6. Prohibited Items',
      'The following items are prohibited on Campus Swap: illegal goods or services, weapons, controlled substances, counterfeit goods, and anything prohibited by law. Violations may result in account suspension or termination.'),
    ('7. Termination',
      'We reserve the right to suspend or terminate your account at our discretion if you violate these Terms of Service or engage in behavior harmful to other users or the platform.'),
    ('8. Limitation of Liability',
      'Campus Swap is provided "as is" without warranties of any kind. We are not liable for any damages arising from your use of the platform, transactions between users, or the conduct of other users.'),
  ];
}
