import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/profile_service.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;
  String _campusLocation = 'Main Campus';

  final _profileService = ProfileService();
  final _storageService = StorageService();

  bool _isSaving = false;
  bool _uploadingAvatar = false;
  String? _newAvatarUrl;

  final _campusOptions = [
    'North Campus',
    'South Campus',
    'West Campus',
    'East Campus',
    'Off Campus',
    'Main Campus',
  ];

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().profile;
    _nameController = TextEditingController(text: user?.name ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _bioController = TextEditingController(text: user?.bio ?? '');
    _campusLocation = user?.campusLocation ?? 'Main Campus';
    if (!_campusOptions.contains(_campusLocation)) {
      _campusOptions.add(_campusLocation);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    setState(() => _uploadingAvatar = true);
    try {
      final file = await _storageService.pickImage();
      if (file != null) {
        final url = await _storageService.uploadAvatar(file);
        setState(() => _newAvatarUrl = url);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to upload photo'),
              backgroundColor: AppColors.alert),
        );
      }
    } finally {
      if (mounted) setState(() => _uploadingAvatar = false);
    }
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Name cannot be empty'),
            backgroundColor: AppColors.alert),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      await _profileService.updateProfile(
        name: name,
        phone: _phoneController.text.trim().isNotEmpty
            ? _phoneController.text.trim()
            : null,
        bio: _bioController.text.trim().isNotEmpty
            ? _bioController.text.trim()
            : null,
        campusLocation: _campusLocation,
        avatarUrl: _newAvatarUrl,
      );
      await context.read<AuthProvider>().refreshProfile();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Profile updated successfully'),
              backgroundColor: AppColors.espresso),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to save profile'),
              backgroundColor: AppColors.alert),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().profile;
    final avatarUrl = _newAvatarUrl ?? user?.avatarUrl;
    final name = _nameController.text;

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.base,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () => Navigator.pop(context)),
        title: Text('Edit Profile',
            style: Theme.of(context).textTheme.titleLarge),
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
                    _avatarWidget(avatarUrl, name, size: 88),
                    if (_uploadingAvatar)
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.black26,
                              shape: BoxShape.circle),
                          child: const Center(
                            child: CircularProgressIndicator(
                                color: AppColors.gold, strokeWidth: 2),
                          ),
                        ),
                      ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _uploadingAvatar ? null : _pickAvatar,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                              color: AppColors.gold,
                              shape: BoxShape.circle),
                          child: const Icon(Icons.camera_alt,
                              size: 14, color: AppColors.espresso),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: _uploadingAvatar ? null : _pickAvatar,
                  child: Text('Change Photo',
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.gold,
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          _label('Full Name'),
          const SizedBox(height: 8),
          TextField(
            controller: _nameController,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(hintText: 'Your name'),
          ),
          const SizedBox(height: 20),

          _label('Email'),
          const SizedBox(height: 8),
          TextField(
            enabled: false,
            controller: TextEditingController(text: user?.email ?? ''),
            decoration: InputDecoration(
              hintText: user?.email ?? '',
              filled: true,
              fillColor: AppColors.cream,
              suffixIcon:
                  const Icon(Icons.lock_outline, size: 16, color: AppColors.stone),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 2),
            child: Text('Email cannot be changed',
                style: GoogleFonts.inter(
                    fontSize: 11, color: AppColors.stone)),
          ),
          const SizedBox(height: 20),

          _label('Phone Number (Optional)'),
          const SizedBox(height: 8),
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration:
                const InputDecoration(hintText: '+91 98765 43210'),
          ),
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
            child: Text('${_bioController.text.length}/500',
                style: GoogleFonts.inter(
                    fontSize: 11, color: AppColors.stone)),
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
                items: _campusOptions
                    .map((loc) =>
                        DropdownMenuItem(value: loc, child: Text(loc)))
                    .toList(),
                onChanged: (v) => setState(() => _campusLocation = v!),
              ),
            ),
          ),
          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSaving ? null : _save,
              child: _isSaving
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Text('Save Changes'),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _avatarWidget(String? avatarUrl, String name, {double size = 80}) {
    if (avatarUrl != null) {
      return ClipOval(
        child: Image.network(
          avatarUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _defaultAvatar(name, size),
        ),
      );
    }
    return _defaultAvatar(name, size);
  }

  Widget _defaultAvatar(String name, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          color: AppColors.gold.withOpacity(0.15), shape: BoxShape.circle),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: GoogleFonts.manrope(
              fontWeight: FontWeight.w700,
              color: AppColors.gold,
              fontSize: size * 0.4),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(text,
      style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.espresso));
}
