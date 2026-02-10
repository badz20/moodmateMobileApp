import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/fcm_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FCMService _fcmService = FCMService();

  User? _firebaseUser;
  UserModel? _userModel;
  bool _isLoading = true;

  User? get firebaseUser => _firebaseUser;
  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _firebaseUser != null;

  AuthProvider() {
    _init();
  }

  void _init() {
    // Listen to auth state changes
    _authService.authStateChanges.listen((User? user) async {
      _firebaseUser = user;

      if (user != null) {
        // Fetch user profile from Firestore
        try {
          _userModel = await _authService.getUserProfile(user.uid);

          // Initialize FCM for the logged-in user
          await _fcmService.initializeFCM();
        } catch (e) {
          debugPrint('Error fetching user profile: $e');
          _userModel = null;
        }
      } else {
        _userModel = null;
      }

      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> refreshUser() async {
    if (_firebaseUser != null) {
      try {
        _userModel = await _authService.getUserProfile(_firebaseUser!.uid);
        notifyListeners();
      } catch (e) {
        debugPrint('Error refreshing user: $e');
      }
    }
  }

  Future<void> signOut() async {
    try {
      // Remove FCM token before signing out (with timeout)
      await _fcmService.removeToken().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          debugPrint('FCM token removal timed out, continuing with sign out');
        },
      );
    } catch (e) {
      debugPrint('Error removing FCM token: $e');
      // Continue with sign out even if FCM removal fails
    }

    await _authService.signOut();
    _firebaseUser = null;
    _userModel = null;
    notifyListeners();
  }
}
