import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:healthka_drivers/assistants/requestAssistant.dart';
import 'package:healthka_drivers/datahandler/appData.dart';
import 'package:healthka_drivers/datahandler/serverData.dart';
import 'package:healthka_drivers/models/ambulanceOrder.dart';
import 'package:healthka_drivers/models/directionDetails.dart';
import 'package:healthka_drivers/models/location.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ServiceAssistant {
  static void setDriverDetails(var driverDetails) {
    driver.driverID = driverDetails['driverID'];
    driver.firstName = driverDetails['firstName'];
    driver.lastName = driverDetails['lastName'];
    driver.phoneNumber = driverDetails['phoneNumber'];
    driver.statusID = driverDetails['statusID'];
    driver.carID = driverDetails['carID'];
  }

  static Future<bool> checkNewDriver(var driverID) async {
    debugPrint("### CALLING checkNewDriver Service ###");
    String url =
        "${serverAPI}api/user/ambulance_driver/checkNewDriver/$driverID";
    debugPrint(url);
    var result = await RequestAssistant.getRequest(url);
    if (result["resSuccess"] == 1) {
      return true;
    }
    setDriverDetails(result['data']);
    if (driver.fcmToken != await FirebaseMessaging.instance.getToken()) {
      await ServiceAssistant.updateFCMToken();
    }
    return false;
  }

  static Future<void> createNewDriver() async {
    var data = newDriver.toJson();
    var result = await RequestAssistant.postRequest(
        "${serverAPI}api/user/ambulance_driver/createNewDriver/", data);
    if (result["resSuccess"] == 1) {
      setDriverDetails(result['data']);
    }
  }

  // static Future<DirectionDetails> getDirectionDetails(
  //     Location start, Location end) async {
  //   var data = {"pickUp": start.toJson(), "dropOff": end.toJson()};
  //   String url = "${serverAPI}api/user/customer/getDirectionDetails/";
  //   var response = await RequestAssistant.postRequest(url, data);
  //   return DirectionDetails.fromJson(response["data"]);
  // }

  static setDriverStatus() async {
    if (driver.statusID == 0) {
      String url =
          "${serverAPI}api/user/ambulance_driver/setDriverStatusToOffline/${driver.driverID}";
      debugPrint(url);
      await RequestAssistant.getRequest(url);
    } else if (driver.statusID == 1) {
      String url =
          "${serverAPI}api/user/ambulance_driver/setDriverStatusToOnline/${driver.driverID}";
      debugPrint(url);
      await RequestAssistant.getRequest(url);
    } else {
      String url =
          "${serverAPI}api/user/ambulance_driver/setDriverStatusToOnRide/${driver.driverID}";
      debugPrint(url);
      await RequestAssistant.getRequest(url);
    }
  }

  static Future<Location?> getCoordinateAddress(Position position) async {
    Location? location;
    var response = await RequestAssistant.getRequest(
        "${serverAPI}api/user/ambulance_driver/getCoordinateAddress/${position.latitude}/${position.longitude}");
    if (response["resSuccess"] == 1) {
      location = Location.fromJson(response["data"]);
    }
    return location;
  }

  static Future<void> updateCurrentLocation() async {
    var data = {"driverID": driver.driverID, "loc": driver.loc!.toJson()};
    var response = await RequestAssistant.postRequest(
        "${serverAPI}api/user/ambulance_driver/setDriverLocation/", data);
  }

  static Future<void> updateFCMToken() async {
    driver.fcmToken = await FirebaseMessaging.instance.getToken();
    var response = await RequestAssistant.getRequest(
        "${serverAPI}api/user/ambulance_driver/setFCMToken/${driver.driverID}/${driver.fcmToken}");
  }

  static Future<void> driverRequestResponse(
      String orderID, bool selected) async {
    await RequestAssistant.postRequest(
        "${serverAPI}api/user/ambulance_order/driverRequestResponse", {
      "driverID": driver.driverID,
      "orderID": orderID,
      "selected": selected
    });
  }

  static Future<void> connectToOrderChannel() async {
    ongoingRideChannel = WebSocketChannel.connect(
      Uri.parse(localOngoingRideWS),
    );
  }

  static Future<void> getOrderUpdatesDriver(orderID) async {
    ongoingRideChannel!.sink.add(jsonEncode({
      "event": "getOrderUpdatesDriver",
      "data": {"orderID": orderID}
    }));
  }

  static Future<void> setCurrentLocation(orderID, Location currentLoc) async {
    ongoingRideChannel!.sink.add(jsonEncode({
      "event": "setCurrentLatLng",
      "data": {"orderID": orderID, "currentLoc": currentLoc.toJson()}
    }));
  }

  static Future<void> patientPickedUp(orderID) async {
    ongoingRideChannel!.sink.add(jsonEncode({
      "event": "patientPickedUp",
      "data": {"orderID": orderID}
    }));
  }

  static Future<void> destinationReached(orderID, Location dropOff) async {
    ongoingRideChannel!.sink.add(jsonEncode({
      "event": "destinationReached",
      "data": {"orderID": orderID, "dropOff": dropOff.toJson()}
    }));
  }

  static Future<void> paymentDone(orderID) async {
    ongoingRideChannel!.sink.add(jsonEncode({
      "event": "paymentDone",
      "data": {"orderID": orderID}
    }));
  }

  static Future<AmbulanceOrder> getBookingByID(orderID) async {
    var response = await RequestAssistant.getRequest(
        "${serverAPI}api/user/ambulance_driver/getBookingByID/$orderID");
    AmbulanceOrder ambulanceOrder = AmbulanceOrder.fromJson(response['data']);
    return ambulanceOrder;
  }

  static Future<List> getBookings() async {
    var response = await RequestAssistant.getRequest(
        "${serverAPI}api/user/ambulance_driver/getBookings/${driver.driverID}");
    debugPrint(response.toString());
    return response['data'];
  }
}
