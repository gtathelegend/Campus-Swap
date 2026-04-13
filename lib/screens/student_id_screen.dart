import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'success_screen.dart';

class StudentIdScreen extends StatefulWidget {
  const StudentIdScreen({super.key});

  @override
  State<StudentIdScreen> createState() => _StudentIdScreenState();
}

class _StudentIdScreenState extends State<StudentIdScreen> {
  String? _fileName;

  @override
  Widget build(BuildContext context) {
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
              Text('Verify student status', style: Theme.of(context).textTheme.displayLarge),
              const SizedBox(height: 8),
              Text('Upload your student ID to get the verified badge', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () => setState(() => _fileName = 'student_id.jpg'),
                child: Container(
                  width: double.infinity,
                  height: 160,
                  decoration: BoxDecoration(
                    color: AppColors.base,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _fileName != null ? AppColors.gold : AppColors.border,
                      width: _fileName != null ? 1.5 : 1,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: _fileName == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.upload_file_outlined, size: 40, color: AppColors.stone),
                            const SizedBox(height: 12),
                            Text('Tap to upload', style: GoogleFonts.inter(color: AppColors.mocha, fontSize: 14, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 4),
                            Text('PNG, JPG or PDF', style: GoogleFonts.inter(color: AppColors.stone, fontSize: 12)),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle_outline, size: 40, color: AppColors.gold),
                            const SizedBox(height: 12),
                            Text(_fileName!, style: GoogleFonts.inter(color: AppColors.espresso, fontSize: 14, fontWeight: FontWeight.w500)),
                          ],
                        ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SuccessScreen())),
                  child: const Text('Continue'),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SuccessScreen())),
                  child: Text('Skip for now', style: GoogleFonts.inter(color: AppColors.mocha, fontSize: 14, decoration: TextDecoration.underline)),
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
