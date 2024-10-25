import 'dart:io';
import 'package:healthka_drivers/models/location.dart';

class Driver {
  String? driverID;
  String? phoneNumber;
  String? firstName;
  String? lastName;
  int? statusID;
  String? carID;
  Location? loc;
  String? fcmToken;
  File? profilePic;
  bool loggedIn = false;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['driverID'] = driverID ?? "";
    data['phoneNumber'] = phoneNumber ?? "";
    data['firstName'] = firstName ?? "";
    data['lastName'] = lastName ?? "";
    data['statusID'] = statusID ?? "";
    data['carID'] = carID ?? "";
    data['fcmToken'] = fcmToken ?? "";
    return data;
  }
}
