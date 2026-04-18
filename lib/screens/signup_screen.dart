import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/brand_title.dart';
import '../theme/app_theme.dart';
import 'verify_screen.dart';
import 'main_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() => _error = 'Please fill in all fields.');
      return;
    }
    if (password.length < 6) {
      setState(() => _error = 'Password must be at least 6 characters.');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final needsVerification =
          await context.read<AuthProvider>().signUp(name, email, password);
      if (mounted) {
        if (needsVerification) {
          // Email confirmation required → show OTP screen
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => VerifyScreen(email: email)),
          );
        } else {
          // Email confirmation disabled → go straight to app
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const MainScreen()),
            (_) => false,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = _friendlyError(e.toString()));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _friendlyError(String raw) {
    final msg = raw.toLowerCase();

    if (msg.contains('already registered') || msg.contains('already exists')) {
      return 'This email is already registered. Try logging in.';
    }
    if (msg.contains('weak') || msg.contains('at least 6 characters')) {
      return 'Password is too weak. Use at least 6 characters.';
    }
    if (msg.contains('invalid email')) {
      return 'Please enter a valid email address.';
    }
    if (msg.contains('over_email_send_rate_limit') ||
        msg.contains('email rate limit exceeded') ||
        msg.contains('rate limit') ||
        msg.contains('429')) {
      return 'Too many sign-up attempts. Please wait a few minutes and try again.';
    }
    if (msg.contains('invalid api key') || msg.contains('statuscode: 401')) {
      return 'Supabase API key is invalid. Update url/anonKey in lib/config/supabase_config.dart using Project Settings -> API.';
    }
    if (msg.contains('signups not allowed')) {
      return 'Signups are disabled in Supabase Auth settings.';
    }
    if (msg.contains('database error saving new user')) {
      return 'Supabase profile setup is incomplete. Run the SQL in SUPABASE_SETUP.md and try again.';
    }

    // Keep backend error visible for faster debugging.
    return raw;
  }

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
        title: const BrandTitle('Campus Swap'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Create Account',
                  style: Theme.of(context).textTheme.displayLarge),
              const SizedBox(height: 8),
              Text('Join Campus Swap',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 32),
              _label('Full Name'),
              const SizedBox(height: 8),
              TextField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(hintText: 'Your name')),
              const SizedBox(height: 20),
              _label('University Email'),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration:
                    const InputDecoration(hintText: 'your@university.edu'),
              ),
              const SizedBox(height: 20),
              _label('Password'),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _signUp(),
                decoration: InputDecoration(
                  hintText: '••••••••',
                  suffixIcon: IconButton(
                    icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.stone),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.alert.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.alert.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline,
                          color: AppColors.alert, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(_error!,
                            style: GoogleFonts.inter(
                                fontSize: 13, color: AppColors.alert)),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _signUp,
                  child: _isLoading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : const Text('Sign Up'),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account? ',
                      style:
                          GoogleFonts.inter(color: AppColors.mocha, fontSize: 14)),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text('Log In',
                        style: GoogleFonts.inter(
                            color: AppColors.gold,
                            fontSize: 14,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(text,
        style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.espresso));
  }
}
