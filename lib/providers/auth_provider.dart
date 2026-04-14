import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/models.dart';
import '../services/auth_service.dart';
import '../services/notification_service.dart';
import '../services/profile_service.dart';

class AuthProvider extends ChangeNotifier {
  final _authService = AuthService();
  final _profileService = ProfileService();

  UserProfile? _profile;
  bool _isLoading = false;
  String? _error;

  UserProfile? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _authService.isLoggedIn;
  String? get currentUserId => _authService.currentUserId;

  AuthProvider() {
    _init();
  }

  Future<void> _init() async {
    // Listen to auth state changes
    Supabase.instance.client.auth.onAuthStateChange.listen((data) async {
      final event = data.event;
      if (event == AuthChangeEvent.signedIn ||
          event == AuthChangeEvent.tokenRefreshed ||
          event == AuthChangeEvent.userUpdated) {
        await NotificationService.instance.startForCurrentUser();
        await loadProfile();
      } else if (event == AuthChangeEvent.signedOut) {
        await NotificationService.instance.stop();
        _profile = null;
        notifyListeners();
      }
    });

    // Load profile if already signed in
    if (isLoggedIn) {
      await NotificationService.instance.startForCurrentUser();
      await loadProfile();
    }
  }

  Future<void> loadProfile() async {
    try {
      _profile = await _profileService.getCurrentProfile();
      notifyListeners();
    } catch (_) {
      // Profile may not exist yet (e.g., right after signup)
    }
  }

  Future<void> signIn(String email, String password) async {
    _setLoading(true);
    try {
      await _authService.signIn(email: email, password: password);
      await loadProfile();
      _clearError();
    } on AuthException catch (e) {
      _setError(e.message);
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Returns true if email confirmation is required (OTP screen needed),
  /// false if the user is immediately signed in (confirmation disabled).
  Future<bool> signUp(String name, String email, String password) async {
    _setLoading(true);
    try {
      final needsVerification = await _authService.signUp(
          name: name, email: email, password: password);
      if (!needsVerification) await loadProfile();
      _clearError();
      return needsVerification;
    } on AuthException catch (e) {
      _setError(e.message);
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    await NotificationService.instance.stop();
    await _authService.signOut();
    _profile = null;
    notifyListeners();
  }

  Future<void> refreshProfile() async {
    await loadProfile();
  }

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  void _setError(String msg) {
    _error = msg;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}
