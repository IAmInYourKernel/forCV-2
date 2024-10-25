import 'package:healthka_customers/models/fare.dart';

class AmbulanceFeature {
  int? featureID;
  String? featureName;
  Fare? featureCost;
  bool? featureSelected;

  AmbulanceFeature();

  AmbulanceFeature.fromJson(Map<String, dynamic> json) {
    featureID = json['featureID'];
    featureName = json['featureName'];
    featureCost =
        json['featureCost'] != null ? Fare.fromJson(json['featureCost']) : null;
    featureSelected = json['featureSelected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['featureID'] = featureID;
    data['featureName'] = featureName;
    if (featureCost != null) {
      data['featureCost'] = featureCost!.toJson();
    }
    data['featureSelected'] = featureSelected;
    return data;
  }
}
