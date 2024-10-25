import 'dart:io';

import 'package:healthka_drivers/models/ambulanceFeature.dart';
import 'package:healthka_drivers/models/ambulanceType.dart';

class Ambulance {
  String? carID;
  String? carManufacturer;
  String? carModel;
  num? year;
  AmbulanceType? type;
  File? picture;
  List<AmbulanceFeature>? features;

  Ambulance();

  Ambulance.fromJson(Map<String, dynamic> json) {
    carID = json['carID'];
    carManufacturer = json['carManufacturer'];
    carModel = json['carModel'];
    type = AmbulanceType.fromJson(json['type']);
    features = [];
    json['features'].forEach((v) {
      features!.add(AmbulanceFeature.fromJson(v));
    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['carID'] = carID;
    data['carManufacturer'] = carManufacturer;
    data['carModel'] = carModel;
    data['year'] = year;
    data['typeID'] = type!.id;
    data['picture'] = "";
    features != null
        ? features!.map((v) => data['features'].add(v.toJson())).toList()
        : null;
    return data;
  }
}
