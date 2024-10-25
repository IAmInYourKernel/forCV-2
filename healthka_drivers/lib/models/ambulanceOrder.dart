import 'package:healthka_drivers/models/ambulance.dart';
import 'package:healthka_drivers/models/ambulanceOrderStatus.dart';
import 'package:healthka_drivers/models/customer.dart';
import 'package:healthka_drivers/models/fare.dart';
import 'package:healthka_drivers/models/location.dart';
import 'package:healthka_drivers/models/patient.dart';

class AmbulanceOrder {
  String? orderID;
  Customer? customer;
  Patient? patient;
  Location? pickUp;
  Location? dropOff;
  Location? currentLoc;
  AmbulanceOrderStatus? status;
  Ambulance? ambulance;
  Fare? estimatedFare;
  Fare? actualFare;

  AmbulanceOrder.fromJson(Map<String, dynamic> json) {
    orderID = json['orderID'];
    customer = Customer.fromJson(json["customer"]);
    patient = Patient.fromJson(json["patient"]);
    pickUp = Location.fromJson(json['loc']['pickUp']);
    dropOff = Location.fromJson(json['loc']['dropOff']);
    currentLoc = Location.fromJson(json['loc']['currentLoc']);
    ambulance = Ambulance.fromJson(json['ambulance']);
    estimatedFare = Fare.fromJson(json['estimatedFare']);
    actualFare = Fare.fromJson(json['actualFare']);
    status = AmbulanceOrderStatus.fromJson(json['orderStatus']);
  }
}
