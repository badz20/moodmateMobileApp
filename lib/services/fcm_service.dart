import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:developer' as developer;

/// Service for managing Firebase Cloud Messaging (FCM) tokens and notifications
class FCMService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Request notification permissions from the user
  Future<bool> requestPermission() async {
    try {
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        developer.log('User granted notification permission');
        return true;
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        developer.log('User granted provisional notification permission');
        return true;
      } else {
        developer.log(
          'User declined or has not accepted notification permission',
        );
        return false;
      }
    } catch (e) {
      developer.log('Error requesting notification permission: $e');
      return false;
    }
  }

  /// Get the current FCM token
  Future<String?> getToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      if (token != null) {
        developer.log('FCM Token obtained: $token');
      } else {
        developer.log('Failed to get FCM token');
      }
      return token;
    } catch (e) {
      developer.log('Error getting FCM token: $e');
      return null;
    }
  }

  /// Save FCM token to the current user's Firestore document
  Future<void> saveTokenToFirestore(String? token) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        developer.log('No user logged in, cannot save FCM token');
        return;
      }

      if (token == null) {
        developer.log('No token to save');
        return;
      }

      await _firestore.collection('users').doc(user.uid).update({
        'fcmToken': token,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      developer.log('FCM token saved to Firestore for user: ${user.uid}');
    } catch (e) {
      developer.log('Error saving FCM token to Firestore: $e');
    }
  }

  /// Initialize FCM for the current user
  /// This should be called after user login
  Future<void> initializeFCM() async {
    // Skip FCM initialization on web platform
    if (kIsWeb) {
      developer.log(
        'FCM notifications not fully supported on web, skipping initialization',
      );
      return;
    }

    try {
      // Request permission
      final hasPermission = await requestPermission();
      if (!hasPermission) {
        developer.log('Notification permission not granted');
        return;
      }

      // Get and save token
      final token = await getToken();
      await saveTokenToFirestore(token);

      // Listen for token refresh
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        developer.log('FCM token refreshed: $newToken');
        saveTokenToFirestore(newToken);
      });

      developer.log('FCM initialized successfully');
    } catch (e) {
      developer.log('Error initializing FCM: $e');
    }
  }

  /// Remove FCM token from Firestore (call on logout)
  Future<void> removeToken() async {
    // Skip on web platform
    if (kIsWeb) {
      developer.log('Skipping FCM token removal on web');
      return;
    }

    try {
      final user = _auth.currentUser;
      if (user == null) {
        developer.log('No user logged in, cannot remove FCM token');
        return;
      }

      // Try to update Firestore with timeout
      await _firestore
          .collection('users')
          .doc(user.uid)
          .update({
            'fcmToken': FieldValue.delete(),
            'updatedAt': FieldValue.serverTimestamp(),
          })
          .timeout(
            const Duration(seconds: 3),
            onTimeout: () {
              developer.log('Timeout updating Firestore, continuing anyway');
            },
          );

      // Try to delete the FCM token from the device (may not work on web)
      try {
        await _firebaseMessaging.deleteToken().timeout(
          const Duration(seconds: 2),
          onTimeout: () {
            developer.log('Timeout deleting FCM token, continuing anyway');
            return null;
          },
        );
      } catch (e) {
        developer.log(
          'Error deleting FCM token (may not be supported on web): $e',
        );
        // Continue anyway, this is not critical
      }

      developer.log('FCM token removed for user: ${user.uid}');
    } catch (e) {
      developer.log('Error removing FCM token: $e');
      // Don't throw, allow sign out to continue
    }
  }

  /// Configure foreground notification presentation options
  Future<void> configureForegroundNotificationOptions() async {
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}
