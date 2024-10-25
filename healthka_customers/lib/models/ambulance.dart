import 'package:healthka_customers/models/ambulanceFeature.dart';
import 'package:healthka_customers/models/ambulanceType.dart';
import 'package:healthka_customers/models/fare.dart';

class Ambulance {
  String? carID;
  String? carManufacturer;
  String? carModel;
  AmbulanceType? type;
  Fare? fareEstimate;
  List<AmbulanceFeature>? features;

  Ambulance();

  Ambulance.fromJson(Map<String, dynamic> json) {
    carID = json['carID'];
    carManufacturer = json['carManufacturer'];
    carModel = json['carModel'];
    type = json['type'] != null ? AmbulanceType.fromJson(json['type']) : null;
    fareEstimate = json['fareEstimate'] != null
        ? Fare.fromJson(json['fareEstimate'])
        : null;
    features = <AmbulanceFeature>[];
    json['features'].forEach((v) {
      features!.add(AmbulanceFeature.fromJson(v));
    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['carID'] = carID;
    data['carManufacturer'] = carManufacturer;
    data['carModel'] = carModel;
    data['type'] = type != null ? type!.toJson() : null;
    data['fareEstimate'] = fareEstimate != null ? fareEstimate!.toJson() : null;
    data['features'] = [];
    features != null
        ? features!.map((v) => data['features'].add(v.toJson())).toList()
        : null;
    return data;
  }
}
