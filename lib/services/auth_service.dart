import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final _client = Supabase.instance.client;

  String? get currentUserId => _client.auth.currentUser?.id;
  String? get currentUserEmail => _client.auth.currentUser?.email;
  bool get isLoggedIn => _client.auth.currentUser != null;

  Stream<AuthState> get authStateStream => _client.auth.onAuthStateChange;

  /// Sign up a new user. Profile row is created via DB trigger.
  /// Returns true if email confirmation is required (OTP sent),
  /// false if the user is immediately signed in (confirmation disabled).
  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {
        'name': name,
        'full_name': name,
        'email': email,
      },
      emailRedirectTo: null, // disable magic-link; OTP code is used instead
    );
    // If session is null after signup, email confirmation is required
    return response.session == null;
  }

  /// Verify email with the 6-digit OTP code sent to the user's inbox.
  Future<void> verifyOtp({
    required String email,
    required String token,
  }) async {
    await _client.auth.verifyOTP(
      email: email,
      token: token,
      type: OtpType.signup, // use signup type for new account confirmation
    );
  }

  /// Resend OTP to email.
  Future<void> resendOtp(String email) async {
    await _client.auth.resend(
      type: OtpType.signup,
      email: email,
    );
  }

  /// Sign in an existing user.
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _client.auth.signInWithPassword(email: email, password: password);
  }

  /// Sign out the current user.
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// Change password for the current user.
  Future<void> updatePassword(String newPassword) async {
    await _client.auth.updateUser(UserAttributes(password: newPassword));
  }

  /// Send password reset email.
  Future<void> resetPassword(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }
}
