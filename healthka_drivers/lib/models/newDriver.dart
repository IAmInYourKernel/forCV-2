import 'package:healthka_drivers/models/ambulance.dart';
import 'package:healthka_drivers/models/driver.dart';
import 'package:healthka_drivers/models/driverDocuments.dart';

class NewDriver {
  Driver? driver;
  DriverDocuments? driverDocuments;
  Ambulance? ambulance;

  NewDriver();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['driver'] = driver!.toJson();
    data['driverDocuments'] = null;
    data['ambulance'] = ambulance!.toJson();
    return data;
  }
}
