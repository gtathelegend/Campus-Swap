import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../data/mock_data.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _bioController;
  String _campusLocation = '';

  final _campusOptions = [
    'North Campus',
    'South Campus',
    'West Campus',
    'East Campus',
    'Off Campus',
  ];

  @override
  void initState() {
    super.initState();
    final user = currentUser;
    _nameController = TextEditingController(text: user.name);
    _phoneController = TextEditingController(text: user.phone ?? '');
    _bioController = TextEditingController(text: user.bio ?? '');
    _campusLocation = user.campusLocation;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _save() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully'), backgroundColor: AppColors.espresso),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.base,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context)),
        title: Text('Edit Profile', style: Theme.of(context).textTheme.titleLarge),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Avatar
          Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.15), shape: BoxShape.circle),
                      child: const Center(child: Text('👤', style: TextStyle(fontSize: 40))),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle),
                        child: const Icon(Icons.camera_alt, size: 14, color: AppColors.espresso),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {},
                  child: Text('Change Photo', style: GoogleFonts.inter(fontSize: 14, color: AppColors.gold, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          _label('Full Name'),
          const SizedBox(height: 8),
          TextField(controller: _nameController, decoration: const InputDecoration(hintText: 'John Smith')),
          const SizedBox(height: 20),

          _label('Email'),
          const SizedBox(height: 8),
          TextField(
            enabled: false,
            controller: TextEditingController(text: currentUser.email),
            decoration: InputDecoration(
              hintText: currentUser.email,
              filled: true,
              fillColor: AppColors.cream,
              suffixIcon: const Icon(Icons.lock_outline, size: 16, color: AppColors.stone),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 2),
            child: Text('Email cannot be changed', style: GoogleFonts.inter(fontSize: 11, color: AppColors.stone)),
          ),
          const SizedBox(height: 20),

          _label('Phone Number (Optional)'),
          const SizedBox(height: 8),
          TextField(controller: _phoneController, keyboardType: TextInputType.phone, decoration: const InputDecoration(hintText: '+1 (555) 000-0000')),
          const SizedBox(height: 20),

          _label('Bio (Optional)'),
          const SizedBox(height: 8),
          TextField(
            controller: _bioController,
            maxLines: 4,
            maxLength: 500,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              hintText: 'Tell buyers a bit about yourself...',
              counterText: '',
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text('${_bioController.text.length}/500', style: GoogleFonts.inter(fontSize: 11, color: AppColors.stone)),
          ),
          const SizedBox(height: 20),

          _label('Campus Location'),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: AppColors.base,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _campusLocation,
                isExpanded: true,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                items: _campusOptions.map((loc) => DropdownMenuItem(value: loc, child: Text(loc))).toList(),
                onChanged: (v) => setState(() => _campusLocation = v!),
              ),
            ),
          ),
          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _save,
              child: const Text('Save Changes'),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _label(String text) => Text(text, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.espresso));
}
