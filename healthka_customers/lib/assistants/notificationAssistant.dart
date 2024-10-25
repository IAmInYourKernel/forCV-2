import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationAssistant {
  static initializeFirebaseMessagingServices() async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingHandler);
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onMessage.listen(firebaseMessagingHandler);
  }

  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    var notificationData = json.decode((message.data)["data"]);
    debugPrint(notificationData.toString());
  }
}
