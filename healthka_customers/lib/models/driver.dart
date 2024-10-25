import 'dart:io';

class Driver {
  String? driverID;
  String? phoneNumber;
  File? picture;

  Driver();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['driverID'] = driverID;
    data['phoneNumber'] = phoneNumber;
    data['picture'] = picture;
    return data;
  }

  Driver.fromJson(Map<String, dynamic> json) {
    driverID = json['driverID'];
    phoneNumber = json['phoneNumber'];
    picture = json['picture'];
  }
}
