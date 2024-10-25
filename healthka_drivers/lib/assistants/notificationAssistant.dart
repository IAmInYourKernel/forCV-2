import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:healthka_drivers/assistants/serviceAssistant.dart';
import 'package:healthka_drivers/datahandler/appData.dart';
import 'package:healthka_drivers/models/ambulanceOrder.dart';
import 'package:healthka_drivers/screens/rideScreen.dart';

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
    if (notificationData["event"] == 0) {
      CallKitParams callKitParams = CallKitParams(
        id: notificationData["orderID"].toString(),
        nameCaller: 'New Ambulance Request',
        appName: 'HealthKa',
        handle: "HealthKa",
        type: 0,
        textAccept: 'Accept',
        textDecline: 'Decline',
        duration: 10000,
        extra: notificationData as Map<String, dynamic>,
        headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
        android: const AndroidParams(
            isCustomNotification: true,
            isShowLogo: false,
            ringtonePath: 'system_ringtone_default',
            backgroundColor: '#0955fa',
            actionColor: '#4CAF50',
            incomingCallNotificationChannelName: "Incoming Call"),
      );
      await FlutterCallkitIncoming.showCallkitIncoming(callKitParams);
      FlutterCallkitIncoming.onEvent.listen((CallEvent? event) {
        switch (event!.event) {
          case Event.actionCallAccept:
            ServiceAssistant.driverRequestResponse(
                notificationData["orderID"].toString(), true);
            break;
          case Event.actionCallDecline:
            ServiceAssistant.driverRequestResponse(
                notificationData["orderID"].toString(), false);
            break;
          case Event.actionDidUpdateDevicePushTokenVoip:
            // TODO: Handle this case.
            break;
          case Event.actionCallIncoming:
            // TODO: Handle this case.
            break;
          case Event.actionCallStart:
            // TODO: Handle this case.
            break;
          case Event.actionCallEnded:
            // TODO: Handle this case.
            break;
          case Event.actionCallTimeout:
            // TODO: Handle this case.
            break;
          case Event.actionCallCallback:
            // TODO: Handle this case.
            break;
          case Event.actionCallToggleHold:
            // TODO: Handle this case.
            break;
          case Event.actionCallToggleMute:
            // TODO: Handle this case.
            break;
          case Event.actionCallToggleDmtf:
            // TODO: Handle this case.
            break;
          case Event.actionCallToggleGroup:
            // TODO: Handle this case.
            break;
          case Event.actionCallToggleAudioSession:
            // TODO: Handle this case.
            break;
          case Event.actionCallCustom:
            // TODO: Handle this case.
            break;
        }
      });
    } else if (notificationData["event"] == 1) {
      // print(requestJson);
      AmbulanceOrder ambulanceOrder =
          await ServiceAssistant.getBookingByID(notificationData['orderID']);
      driver.statusID = 2;
      navigatorKey.currentState!.push(
        MaterialPageRoute(builder: (context) => RideScreen(ambulanceOrder)),
      );
    }
  }
}
