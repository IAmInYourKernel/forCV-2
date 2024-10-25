import 'package:healthka_customers/models/ambulance.dart';
import 'package:healthka_customers/models/directionDetails.dart';

class RideDetails {
  late DirectionDetails directionDetails;
  late List<Ambulance> ambulanceList;

  RideDetails({required this.directionDetails, required this.ambulanceList});

  RideDetails.fromJson(Map<String, dynamic> json) {
    directionDetails = DirectionDetails.fromJson(json['directionDetails']);
    ambulanceList = <Ambulance>[];
    json['ambulanceList'].forEach((v) {
      ambulanceList.add(Ambulance.fromJson(v));
    });
  }
}
