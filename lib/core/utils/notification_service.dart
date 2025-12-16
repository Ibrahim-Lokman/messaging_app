import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Request Permission
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Foreground Handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        _showLocalNotification(message);
      }
    });
    
    // Background Handler: Must be a top-level function, handled in main usually.
    
    // Init Local Notifications for displaying foreground heads-up
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);
    await _localNotifications.initialize(initSettings);
  }

  Future<void> saveToken(String userId) async {
    final token = await _firebaseMessaging.getToken();
    if (token != null) {
      await _firestore.collection('users').doc(userId).update({
        'fcmToken': token,
      });
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    final android = message.notification?.android;
    
    if (notification != null && android != null) {
       // Need Channels for Android 8+
       // Omitting channel init for brevity, assuming using default channel or init elsewhere
       
       const androidDetails = AndroidNotificationDetails(
         'default_channel', 
         'Default Channel',
         importance: Importance.max,
         priority: Priority.high,
       );
       const details = NotificationDetails(android: androidDetails);
       
       await _localNotifications.show(
         notification.hashCode,
         notification.title,
         notification.body,
         details,
       );
    }
  }
}
