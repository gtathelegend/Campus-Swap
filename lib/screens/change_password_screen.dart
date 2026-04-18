import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/brand_title.dart';
import '../theme/app_theme.dart';
import '../services/auth_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _showCurrent = false;
  bool _showNew = false;
  bool _showConfirm = false;
  bool _typing = false;
  bool _loading = false;
  final _authService = AuthService();

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  bool get _canUpdate =>
      _currentController.text.isNotEmpty &&
      _newController.text.length >= 8 &&
      _newController.text == _confirmController.text;

  Future<void> _update() async {
    setState(() => _loading = true);
    try {
      await _authService.updatePassword(_newController.text);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password updated successfully'), backgroundColor: AppColors.espresso),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll('Exception: ', '')), backgroundColor: AppColors.alert),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.base,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context)),
        title: const BrandTitle('Change Password'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _label('Current Password'),
          const SizedBox(height: 8),
          _passwordField(_currentController, _showCurrent, () => setState(() => _showCurrent = !_showCurrent)),
          const SizedBox(height: 20),

          _label('New Password'),
          const SizedBox(height: 8),
          _passwordField(_newController, _showNew, () => setState(() => _showNew = !_showNew),
              onChanged: (_) => setState(() => _typing = true)),
          const SizedBox(height: 20),

          _label('Confirm New Password'),
          const SizedBox(height: 8),
          _passwordField(_confirmController, _showConfirm, () => setState(() => _showConfirm = !_showConfirm),
              onChanged: (_) => setState(() {})),
          const SizedBox(height: 16),

          // Password requirements
          AnimatedOpacity(
            opacity: _typing ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.goldLight,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.gold.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Password Requirements', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.espresso)),
                  const SizedBox(height: 8),
                  _requirement('At least 8 characters', _newController.text.length >= 8),
                  _requirement('At least 1 uppercase', _newController.text.contains(RegExp(r'[A-Z]'))),
                  _requirement('At least 1 number', _newController.text.contains(RegExp(r'[0-9]'))),
                  _requirement('At least 1 special character', _newController.text.contains(RegExp(r'[!@#\$%^&*]'))),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (_canUpdate && !_loading) ? _update : null,
              style: ElevatedButton.styleFrom(
                disabledBackgroundColor: AppColors.border,
                disabledForegroundColor: AppColors.stone,
              ),
              child: _loading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Update Password'),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _passwordField(TextEditingController controller, bool show, VoidCallback toggle, {void Function(String)? onChanged}) {
    return TextField(
      controller: controller,
      obscureText: !show,
      onChanged: (v) { setState(() {}); onChanged?.call(v); },
      decoration: InputDecoration(
        hintText: '••••••••',
        suffixIcon: IconButton(
          icon: Icon(show ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppColors.stone, size: 20),
          onPressed: toggle,
        ),
      ),
    );
  }

  Widget _requirement(String text, bool met) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(met ? Icons.check_circle : Icons.circle_outlined, size: 14, color: met ? const Color(0xFF4CAF50) : AppColors.stone),
          const SizedBox(width: 8),
          Text(text, style: GoogleFonts.inter(fontSize: 12, color: met ? AppColors.espresso : AppColors.stone)),
        ],
      ),
    );
  }

  Widget _label(String text) => Text(text, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.espresso));
}
