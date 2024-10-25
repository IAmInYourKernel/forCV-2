import 'package:healthka_customers/models/fare.dart';

class AmbulanceType {
  num? id;
  String? name;
  Fare? baseFare;
  Fare? costPerKM;
  Fare? costPerMin;

  AmbulanceType();

  AmbulanceType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    baseFare = Fare.fromJson(json['baseFare']);
    costPerKM = Fare.fromJson(json['costPerKM']);
    costPerMin = Fare.fromJson(json['costPerMin']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['baseFare'] = baseFare!.toJson();
    data['costPerKM'] = costPerKM!.toJson();
    data['costPerMin'] = costPerMin!.toJson();
    return data;
  }
}
