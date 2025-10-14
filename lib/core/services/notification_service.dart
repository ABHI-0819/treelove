/*
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class LocalNotificationService {

  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static void initialize() {
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
    );

    _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint('Notification clicked: ${response.payload}');
      },
    );
  }

  static Future<void> requestPermissions() async {
    if (Platform.isAndroid){
      await Permission.notification.request();
    }
    if (Platform.isIOS) {
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'channel_id',
      'Channel Name',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

}

 */

/// Firebase
/*
Public-facing name for project
This will be the name presented to users when they are shown any public instances of your project. For example, this will be the name displayed on emails that your users receive after creating an account with your app.
project-359037552305



 */

import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_app_installations/firebase_app_installations.dart';
import 'package:flutter/foundation.dart';

class FirebasePushService {

  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  // static FirebaseInAppMessaging? _inAppMessaging;
  static String? _fcmToken;
  static String? _installationId;

  /// Initialize Firebase Push Notification Service
  static Future<void> initialize() async {
    // Request notification permissions
    await _requestPermissions();

    // Get FCM token
    await _getFCMToken();

    // Get Installation ID
    await _getInstallationId();

    // Set up message handlers
    _setupMessageHandlers();
  }

  /// Request notification permissions
  static Future<NotificationSettings> _requestPermissions() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (kDebugMode) {
      print('Permission granted: ${settings.authorizationStatus}');
    }

    return settings;
  }

  /// Get FCM token and handle token refresh
  static Future<void> _getFCMToken() async {
    try {
      // For iOS, ensure APNS token is available first
      if (Platform.isIOS) {
        String? apnsToken = await _messaging.getAPNSToken();
        if (apnsToken == null) {
          // Wait for APNS token
          await Future.delayed(const Duration(seconds: 3));
          apnsToken = await _messaging.getAPNSToken();
        }
      }

      // Get FCM token
      _fcmToken = await _messaging.getToken();

      if (kDebugMode) {
        print('FCM Token: $_fcmToken');
      }

      // Send token to your server
      if (_fcmToken != null) {
        await _sendTokenToServer(_fcmToken!);
      }

      // Listen for token refresh
      _messaging.onTokenRefresh.listen((newToken) {
        _fcmToken = newToken;
        if (kDebugMode) {
          print('Token refreshed: $newToken');
        }
        _sendTokenToServer(newToken);
      });

    } catch (e) {
      if (kDebugMode) {
        print('Error getting FCM token: $e');
      }
    }
  }

  /// Get Firebase Installation ID
  static Future<void> _getInstallationId() async {
    try {
      _installationId = await FirebaseInstallations.instance.getId();

      if (kDebugMode) {
        print('✅ Installation ID retrieved: $_installationId');
      }

      // Send Installation ID to your server
      if (_installationId != null) {
        await _sendInstallationIdToServer(_installationId!);
      }

    } catch (e) {
      if (kDebugMode) {
        print('❌ Error getting Installation ID: $e');
      }
    }
  }

  /// Setup message handlers for different app states
  static void _setupMessageHandlers() {
    // Foreground messages (app is active)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('📱 Foreground Message Received');
        print('Title: ${message.notification?.title}');
        print('Body: ${message.notification?.body}');
        print('Type: ${message.data['type'] ?? 'general'}');
        print('Data: ${message.data}');
      }

      // Handle foreground message
      _handleForegroundMessage(message);
    });



    // Background messages (app opened from notification)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('🔔 Background Message Opened App');
        print('Title: ${message.notification?.title}');
        print('Data: ${message.data}');
      }

      // Handle notification tap
      _handleNotificationTap(message);
    });

    // Handle initial message (app opened from terminated state)
    _getInitialMessage();
  }

  /// Send Installation ID to your server
  static Future<void> _sendInstallationIdToServer(String installationId) async {
    try {
      // TODO: Replace with your actual API endpoint
      /*
      final response = await http.post(
        Uri.parse('https://your-api.com/installation-id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'installation_id': installationId,
          'platform': Platform.isIOS ? 'ios' : 'android',
          'app_version': await _getAppVersion(),
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );
      */

      if (kDebugMode) {
        print('📤 Installation ID sent to server: $installationId');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to send Installation ID to server: $e');
      }
    }
  }


  /// Handle messages when app is in foreground
  static void _handleForegroundMessage(RemoteMessage message) {
    // Process foreground message
    final data = message.data;

    // Handle different message types
    switch (data['type']) {
      case 'chat':
        _handleChatMessage(message);
        break;
      case 'order':
        _handleOrderMessage(message);
        break;
      case 'update':
        _handleUpdateMessage(message);
        break;
      default:
        _handleGeneralMessage(message);
    }
  }

  /// Handle notification tap when app is in background/terminated
  static void _handleNotificationTap(RemoteMessage message) {
    final data = message.data;

    if (kDebugMode) {
      print('Notification tapped with data: $data');
    }

    // Navigate based on notification type or route
    if (data.containsKey('route')) {
      _navigateToRoute(data['route'], data);
    } else if (data.containsKey('type')) {
      _navigateByType(data['type'], data);
    }
  }

  /// Get initial message if app was opened from notification
  static Future<void> _getInitialMessage() async {
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();

    if (initialMessage != null) {
      if (kDebugMode) {
        print('🚀 App opened from terminated state via notification');
        print('Title: ${initialMessage.notification?.title}');
      }

      // Handle the initial message
      _handleNotificationTap(initialMessage);
    }
  }

  /// Send FCM token to your server
  static Future<void> _sendTokenToServer(String token) async {
    try {
      // TODO: Replace with your actual API endpoint
      /*
      final response = await http.post(
        Uri.parse('https://your-api.com/fcm-token'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'token': token,
          'platform': Platform.isIOS ? 'ios' : 'android',
          'user_id': getCurrentUserId(), // Your user identification
        }),
      );
      */

      if (kDebugMode) {
        print('✅ Token sent to server: $token');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to send token to server: $e');
      }
    }
  }

  /// Handle different message types
  static void _handleChatMessage(RemoteMessage message) {
    // Handle chat-specific logic
    if (kDebugMode) {
      print('💬 Chat message received');
    }
  }

  static void _handleOrderMessage(RemoteMessage message) {
    // Handle order-specific logic
    if (kDebugMode) {
      print('📦 Order message received');
    }
  }

  static void _handleUpdateMessage(RemoteMessage message) {
    // Handle app update logic
    if (kDebugMode) {
      print('🔄 Update message received');
    }
  }

  static void _handleGeneralMessage(RemoteMessage message) {
    // Handle general notifications
    if (kDebugMode) {
      print('📢 General message received');
    }
  }

  /// Navigate to specific route based on notification data
  static void _navigateToRoute(String route, Map<String, dynamic> data) {
    // TODO: Implement navigation logic
    // Example: Get.toNamed(route, arguments: data);
    if (kDebugMode) {
      print('🧭 Navigate to route: $route with data: $data');
    }
  }

  /// Navigate based on message type
  static void _navigateByType(String type, Map<String, dynamic> data) {
    switch (type) {
      case 'chat':
      // Navigate to chat screen
        if (kDebugMode) print('Navigate to chat');
        break;
      case 'order':
      // Navigate to order details
        if (kDebugMode) print('Navigate to order');
        break;
      default:
      // Navigate to home or default screen
        if (kDebugMode) print('Navigate to home');
    }
  }

  /// Subscribe to a topic
  static Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      if (kDebugMode) {
        print('✅ Subscribed to topic: $topic');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to subscribe to topic $topic: $e');
      }
    }
  }

  /// Unsubscribe from a topic
  static Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      if (kDebugMode) {
        print('✅ Unsubscribed from topic: $topic');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to unsubscribe from topic $topic: $e');
      }
    }
  }

  /// Get current FCM token
  static String? get fcmToken => _fcmToken;

  /// Check if notifications are enabled
  static Future<bool> areNotificationsEnabled() async {
    final settings = await _messaging.getNotificationSettings();
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }
}
