import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:healthka_drivers/models/ambulance.dart';
import 'package:healthka_drivers/models/driver.dart';
import 'package:healthka_drivers/models/driverDocuments.dart';
import 'package:healthka_drivers/models/newDriver.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Driver driver = Driver();

NewDriver newDriver = NewDriver();

const AndroidNotificationChannel importantNotiChannel =
    AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.max,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
