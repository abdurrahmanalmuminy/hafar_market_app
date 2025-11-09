import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hafar_market_app/main.dart';
import 'package:hafar_market_app/models/offer_model.dart';
import 'package:hafar_market_app/ui/screens/offer_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Background message: ${message.messageId}");
}

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> initialize() async {
    try {
      // Request permission
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        debugPrint('User granted permission');
      } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
        debugPrint('User granted provisional permission');
      } else {
        debugPrint('User declined or has not accepted permission');
      }

      // Get FCM token - handle APNS token not set error on iOS
      try {
        final token = await _messaging.getToken();
        debugPrint('FCM Token: $token');

        // Save token to Firestore (if user is logged in)
        if (token != null) {
          await _saveTokenToFirestore(token);
        }
      } catch (e) {
        // On iOS, APNS token might not be available yet (especially on simulator)
        // This is not a fatal error - token will be available later
        debugPrint('Could not get FCM token yet (APNS may not be ready): $e');
        // Token will be retrieved when APNS token becomes available via onTokenRefresh
      }

      // Listen for token refresh
      _messaging.onTokenRefresh.listen((newToken) {
        debugPrint('New FCM Token: $newToken');
        _saveTokenToFirestore(newToken);
      });

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle notification taps when app is in background
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

      // Set background message handler
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    } catch (e) {
      debugPrint('Error initializing NotificationService: $e');
      // Don't rethrow - allow app to continue without notifications
    }
  }

  Future<void> _saveTokenToFirestore(String token) async {
    // This should be called with user ID when user is logged in
    // For now, we'll save it to a generic collection
    try {
      await _firestore.collection('fcm_tokens').doc(token).set({
        'token': token,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error saving FCM token: $e');
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('Foreground message: ${message.messageId}');
    // Show in-app notification or update UI
  }

  Future<void> _handleNotificationTap(RemoteMessage message) async {
    debugPrint('Notification tapped: ${message.messageId}');
    final data = message.data;

    // Handle offer notification
    if (data.containsKey('offerId')) {
      final offerId = data['offerId'] as String;
      final doc = await _firestore.collection('offers').doc(offerId).get();
      if (doc.exists) {
        final offer = OfferModel.fromMap(doc.data() as Map<String, dynamic>);
        rootNavigatorKey.currentState?.push(
          MaterialPageRoute(builder: (_) => OfferPage(offer: offer)),
        );
      }
    }
  }
}

