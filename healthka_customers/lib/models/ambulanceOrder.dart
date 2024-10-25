import 'package:healthka_customers/models/ambulance.dart';
import 'package:healthka_customers/models/ambulanceOrderStatus.dart';
import 'package:healthka_customers/models/customer.dart';
import 'package:healthka_customers/models/driver.dart';
import 'package:healthka_customers/models/fare.dart';
import 'package:healthka_customers/models/location.dart';
import 'package:healthka_customers/models/patient.dart';

class AmbulanceOrder {
  String? orderID;
  Customer? customer;
  Driver? driver;
  Patient? patient;
  Location? pickUp;
  Location? dropOff;
  Location? currentLoc;
  AmbulanceOrderStatus? orderStatus;
  Ambulance? ambulance;
  Fare? estimatedFare;
  Fare? actualFare;

  AmbulanceOrder();

  AmbulanceOrder.fromJson(Map<String, dynamic> json) {
    orderID = json['orderID'];
    customer = Customer.fromJson(json["customer"]);
    patient = Patient.fromJson(json["patient"]);
    driver = Driver.fromJson(json['driver']);
    pickUp = Location.fromJson(json['loc']['pickUp']);
    dropOff = Location.fromJson(json['loc']['dropOff']);
    currentLoc = Location.fromJson(json['loc']['currentLoc']);
    ambulance = Ambulance.fromJson(json['ambulance']);
    estimatedFare = Fare.fromJson(json['estimatedFare']);
    actualFare = Fare.fromJson(json['actualFare']);
    orderStatus = AmbulanceOrderStatus.fromJson(json['orderStatus']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orderID'] = orderID;
    data['customer'] = customer != null ? customer!.toJson() : null;
    data['patient'] = patient != null ? patient!.toJson() : null;
    data['driver'] = driver != null ? driver!.toJson() : null;
    data['pickUp'] = pickUp != null ? pickUp!.toJson() : null;
    data['dropOff'] = dropOff != null ? dropOff!.toJson() : null;
    data['currentLoc'] = currentLoc != null ? currentLoc!.toJson() : null;
    data['orderStatus'] = orderStatus != null ? orderStatus!.toJson() : null;
    data['ambulance'] = ambulance != null ? ambulance!.toJson() : null;
    data['estimatedFare'] =
        estimatedFare != null ? estimatedFare!.toJson() : null;
    data['actualFare'] = actualFare != null ? actualFare!.toJson() : null;
    return data;
  }
}
