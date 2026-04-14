import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../services/storage_service.dart';
import '../services/profile_service.dart';
import '../theme/app_theme.dart';
import 'success_screen.dart';

class StudentIdScreen extends StatefulWidget {
  const StudentIdScreen({super.key});

  @override
  State<StudentIdScreen> createState() => _StudentIdScreenState();
}

class _StudentIdScreenState extends State<StudentIdScreen> {
  XFile? _file;
  bool _uploading = false;
  String? _error;
  final _storage = StorageService();
  final _profileService = ProfileService();

  Future<void> _pickFile() async {
    final picked = await _storage.pickImage(fromCamera: false);
    if (picked != null) {
      setState(() {
        _file = picked;
        _error = null;
      });
    }
  }

  Future<void> _pickFromCamera() async {
    final picked = await _storage.pickImage(fromCamera: true);
    if (picked != null) {
      setState(() {
        _file = picked;
        _error = null;
      });
    }
  }

  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.base,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined,
                  color: AppColors.espresso),
              title: Text('Choose from gallery',
                  style: GoogleFonts.inter(fontSize: 15)),
              onTap: () {
                Navigator.pop(context);
                _pickFile();
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.camera_alt_outlined, color: AppColors.espresso),
              title:
                  Text('Take a photo', style: GoogleFonts.inter(fontSize: 15)),
              onTap: () {
                Navigator.pop(context);
                _pickFromCamera();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_file == null) {
      setState(() => _error = 'Please select your student ID first.');
      return;
    }
    setState(() {
      _uploading = true;
      _error = null;
    });
    try {
      final url = await _storage.uploadStudentId(_file!);
      await _profileService.submitStudentVerification(url);
      if (mounted) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const SuccessScreen()));
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = 'Upload failed. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fileName = _file?.name ?? _file?.path.split('/').last;

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Verify student status',
                  style: Theme.of(context).textTheme.displayLarge),
              const SizedBox(height: 8),
              Text(
                  'Upload your student ID to get the verified badge on your profile.',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 32),

              // Upload area
              GestureDetector(
                onTap: _showPickerOptions,
                child: Container(
                  width: double.infinity,
                  height: 160,
                  decoration: BoxDecoration(
                    color: AppColors.base,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _file != null ? AppColors.gold : AppColors.border,
                      width: _file != null ? 1.5 : 1,
                    ),
                  ),
                  child: _file == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.upload_file_outlined,
                                size: 40, color: AppColors.stone),
                            const SizedBox(height: 12),
                            Text('Tap to upload',
                                style: GoogleFonts.inter(
                                    color: AppColors.mocha,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500)),
                            const SizedBox(height: 4),
                            Text('Photo from gallery or camera',
                                style: GoogleFonts.inter(
                                    color: AppColors.stone, fontSize: 12)),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check_circle_outline,
                                size: 40, color: AppColors.gold),
                            const SizedBox(height: 12),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                fileName ?? 'File selected',
                                style: GoogleFonts.inter(
                                    color: AppColors.espresso,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text('Tap to change',
                                style: GoogleFonts.inter(
                                    color: AppColors.stone, fontSize: 12)),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 16),

              // Info note
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.goldLight,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: AppColors.gold.withValues(alpha: 0.3)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.lock_outline,
                        size: 16, color: AppColors.mocha),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Your ID is stored securely and only used for verification. It will not be visible to other users.',
                        style:
                            GoogleFonts.inter(fontSize: 12, color: AppColors.mocha),
                      ),
                    ),
                  ],
                ),
              ),

              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!,
                    style: GoogleFonts.inter(
                        fontSize: 13, color: AppColors.alert)),
              ],

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _uploading ? null : _submit,
                  child: _uploading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : const Text('Submit for Verification'),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const SuccessScreen())),
                  child: Text('Skip for now',
                      style: GoogleFonts.inter(
                          color: AppColors.mocha,
                          fontSize: 14,
                          decoration: TextDecoration.underline)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
