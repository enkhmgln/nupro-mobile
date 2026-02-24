import 'package:firebase_core/firebase_core.dart';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:g_json/g_json.dart';
import 'package:nuPro/library/library.dart';
import 'package:nuPro/library/routes/dynamic_route.dart';
import 'package:nuPro/library/routes/home_route.dart';
import 'package:nuPro/library/components/widgets/incoming_call_modal.dart';

class MainConfig {
  static final flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static List<RemoteMessage> pendingMessages = [];

  static Future setOrientationConfig() async {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  static Future<void> setStoreConfig() async {
    await UserStoreManager.shared.init();
    await DeviceStoreManager.shared.init();
  }

  static Future<void> setFirebaseConfig() async {
    await Firebase.initializeApp();
    await FirebaseMessaging.instance.requestPermission();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    const initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initializationSettingsDarwin = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: DynamicRoute.onNotification,
      onDidReceiveBackgroundNotificationResponse: DynamicRoute.onNotification,
    );

    // Background handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Foreground handler
    FirebaseMessaging.onMessage.listen((message) async {
      await showAndroidMessage(message);
      print("🔥 Foreground message: ${message.data}");

      _handleMessage(message);
    });

    // Tapped notification when app is terminated or background
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      print("📩 onMessageOpenedApp tapped: ${message.data}");
      _handleMessage(message, isFromNotificationTap: true);
    });

    // Handle initial message when app is launched from notification
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      print("📩 Initial message: ${initialMessage.data}");
      _handleMessage(initialMessage, isFromNotificationTap: true);
    }
  }

  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    await Firebase.initializeApp();
    print("Background message received: ${message.data}");

    // Initialize local notifications for background
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        ),
        macOS: DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        ),
      ),
      onDidReceiveNotificationResponse: DynamicRoute.onNotification,
    );

    await MainConfig.showAndroidMessage(message);
    _handleMessage(message, isFromNotificationTap: true);
  }

  static Future<void> showAndroidMessage(RemoteMessage message) async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    final notification = message.notification;
    if (notification != null) {
      await flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: '@mipmap/ic_launcher',
            importance: Importance.max,
            priority: Priority.high,
            fullScreenIntent: true,
          ),
        ),
        payload: JSON(message.data).rawString(),
      );
    }
  }

  static void _handleMessage(
    RemoteMessage message, {
    bool isFromNotificationTap = false,
  }) async {
    final pageType = message.data['page_type'];
    print("🔍 _handleMessage called with pageType: $pageType");
    print("🔍 Message data: ${message.data}");
    print("🔍 Message notification: ${message.notification?.toMap()}");
    print("🔍 Message messageId: ${message.messageId}");
    print("🔍 Message from: ${message.from}");
    print("🔍 Message collapseKey: ${message.collapseKey}");
    print("🔍 Message sentTime: ${message.sentTime}");
    print("🔍 Message ttl: ${message.ttl}");
    print("🔍 isFromNotificationTap: $isFromNotificationTap");

    if (pageType == 'incoming_call') {
      print("📞 Handling incoming call...");

      // Extract additional data for better call handling
      final callId = message.data['page_id'];
      final callerName = message.data['caller_name'] ?? 'Хэрэглэгч';
      final callerPhone = message.data['caller_phone'] ?? '';
      final profilePicture = message.data['profile_picture'];
      final locationText = message.data['location'];

      // Parse optional nested objects that may arrive as JSON strings
      Map<String, dynamic>? toMap(dynamic raw) {
        try {
          if (raw == null) return null;
          if (raw is Map<String, dynamic>) return raw;
          if (raw is Map) return Map<String, dynamic>.from(raw);
          if (raw is String && raw.trim().isNotEmpty) {
            final decoded = jsonDecode(raw);
            if (decoded is Map) return Map<String, dynamic>.from(decoded);
          }
        } catch (_) {}
        return null;
      }

      final locMap = toMap(message.data['caller_location']);
      final healthMap = toMap(message.data['caller_health_info']);
      final double? latitude = (locMap?['latitude'] as num?)?.toDouble();
      final double? longitude = (locMap?['longitude'] as num?)?.toDouble();
      final callStatus = message.data['call_status'];
      final callType = message.data['call_type'];
      final tsStr = message.data['timestamp']?.toString();
      final DateTime? timestamp =
          tsStr != null && tsStr.isNotEmpty ? DateTime.tryParse(tsStr) : null;

      // If notification was tapped (app was killed/background), try direct call first
      if (isFromNotificationTap) {
        print("📱 Notification tapped, attempting direct call handling");

        // Try to handle the call directly first
        try {
          await DynamicRoute.sendCallToNurse(
            callId: callId,
            callerName: callerName,
            callerPhone: callerPhone,
            latitude: latitude,
            longitude: longitude,
            healthInfo:
                healthMap != null ? CallerHealthInfo.fromJson(healthMap) : null,
            callStatus: callStatus,
            callType: callType,
            timestamp: timestamp,
          );
        } catch (e) {
          print("❌ Direct call handling failed: $e");
          // Fallback to storing data
          DeviceStoreManager.shared.write(
            'pending_incoming_call',
            {
              'call_id': callId,
              'caller_name': callerName,
              'caller_phone': callerPhone,
              'profile_picture': profilePicture,
              'location': locationText,
              'latitude': latitude,
              'longitude': longitude,
              'health_info': healthMap,
              'call_status': callStatus,
              'call_type': callType,
              'timestamp': DateTime.now().toIso8601String(),
            },
          );
        }
      } else {
        // App is in foreground, show CallKit
        print("📞 App in foreground, calling sendCallToNurse...");
        DynamicRoute.sendCallToNurse(
          callId: callId,
          callerName: callerName,
          callerPhone: callerPhone,
          latitude: latitude,
          longitude: longitude,
          healthInfo:
              healthMap != null ? CallerHealthInfo.fromJson(healthMap) : null,
          callStatus: callStatus,
          callType: callType,
          timestamp: timestamp,
        );
      }
    } else if (pageType == 'call_status_change') {
      if (HelperManager.isLogged) {
        DynamicRoute.onRoute(
          pageType: pageType,
          pageId: message.data['page_id'],
          sectionTitle: message.data['section_title'],
          callStatus: message.data['call_status'],
          callType: message.data['call_type'],
          paymentId: int.tryParse(message.data['payment_id'] ?? '0'),
          paymentApiUri: message.data['payment_api_url'],
          amount: int.tryParse(message.data['amount'] ?? '0'),
          currency: message.data['currency'],
        );
      } else {
        pendingMessages.add(message);
      }
    } else if (pageType == 'booking' ||
        message.data['action_type'] == 'booking') {
      // Handle booking completion notification - navigate to rating screen
      print("📩 Handling booking completion notification");
      final actionId = message.data['action_id'] ?? message.data['page_id'];
      final title =
          message.data['title'] ?? message.data['section_title'] ?? '';

      if (title == 'Үйлчилгээ дууслаа' && actionId != null) {
        print(
            "🎯 Service completed, navigating to rating screen for actionId: $actionId");
        if (HelperManager.isLogged) {
          // Аль ч хэрэглэгчийн хувьд үнэлгээний дэлгэц рүү шилжүүлнэ
          // Get.find<MainController>().getUserInfo();
          HomeRoute.toRating(callId: int.tryParse(actionId.toString()) ?? 0);
        } else {
          // Store for later when user logs in
          pendingMessages.add(message);
        }
      } else {
        showAndroidMessage(message);
      }
    } else if (message.data.isEmpty && message.notification != null) {
      // Handle notification with only title/body, no data payload
      print("📩 Handling notification without data payload");
      final notificationTitle = message.notification?.title ?? '';
      final notificationBody = message.notification?.body ?? '';

      print("🔍 Notification title: $notificationTitle");
      print("🔍 Notification body: $notificationBody");

      // Check if it's a service completion notification
      if (notificationTitle == 'Үйлчилгээ дууслаа' ||
          notificationTitle.contains('дууслаа') ||
          notificationBody.contains('дууслаа')) {
        print("🎯 Service completion notification detected from title/body");

        // Try to extract call ID from body or use a default
        int? callId;
        final bodyMatch =
            RegExp(r'call[_\s]*id[:\s]*(\d+)', caseSensitive: false)
                .firstMatch(notificationBody);
        if (bodyMatch != null) {
          callId = int.tryParse(bodyMatch.group(1) ?? '');
        }

        if (callId != null) {
          print("🎯 Extracted call ID from body: $callId");
          if (HelperManager.isLogged) {
            HomeRoute.toRating(callId: callId);
          } else {
            pendingMessages.add(message);
          }
        } else {
          print(
              "⚠️ Could not extract call ID from body, trying notifications API fallback");
          await _tryNavigateToRatingFromLatestNotification();
        }
      } else {
        showAndroidMessage(message);
      }
    } else {
      showAndroidMessage(message);
    }
  }

  static Future<void> _tryNavigateToRatingFromLatestNotification() async {
    try {
      if (!HelperManager.isLogged) {
        print('⚠️ User not logged in, skipping fallback navigation');
        return;
      }

      final response =
          await CustomerApi().getNotificationList(limit: 10, page: 1);
      if (!response.isSuccess) {
        print(
            '❌ Failed to fetch notifications for fallback: ${response.message}');
        return;
      }

      final items = response.data.listValue;
      int? actionId;

      for (final item in items) {
        final title = item['title'].stringValue;
        final body = item['body'].stringValue;
        final type = item['notif_type'].stringValue;
        final aType = item['action_type'].stringValue;

        final looksComplete = title == 'Үйлчилгээ дууслаа' ||
            title.contains('дууслаа') ||
            body.contains('дууслаа') ||
            type == 'booking' ||
            aType == 'booking';

        if (looksComplete) {
          actionId = item['action_id'].integerValue;
          if (actionId > 0) break;
        }
      }

      if (actionId != null && actionId > 0) {
        print('🎯 Fallback found actionId=$actionId, navigating to rating');
        HomeRoute.toRating(callId: actionId);
      } else {
        print(
            '⚠️ Fallback could not find matching notification, showing local notification only');
      }
    } catch (e) {
      print('❌ Fallback navigation error: $e');
    }
  }

  static void handlePendingMessagesAfterLogin() {
    for (var message in pendingMessages) {
      _handleMessage(message, isFromNotificationTap: true);
    }
    pendingMessages.clear();
  }

  // Test method to simulate booking completion notification
  static void testBookingCompletionNotification() {
    print("🧪 Testing booking completion notification...");

    const testMessage = RemoteMessage(
      data: {
        'page_type': 'booking',
        'action_type': 'booking',
        'action_id': '14',
        'title': 'Үйлчилгээ дууслаа',
        'section_title': 'Үйлчилгээ дууслаа',
        'body':
            'Sumiya Narantsetseg сувилагчийн үйлчилгээ амжилттай дууслаа. Үнэлгээ өгөх боломжтой.',
      },
      notification: RemoteNotification(
        title: 'Үйлчилгээ дууслаа',
        body:
            'Sumiya Narantsetseg сувилагчийн үйлчилгээ амжилттай дууслаа. Үнэлгээ өгөх боломжтой.',
      ),
    );

    _handleMessage(testMessage, isFromNotificationTap: true);
  }
}
