class Patient {
  String? patientID;
  String? name;
  String? phoneNumber;

  Patient.fromJson(Map<String, dynamic> json) {
    patientID = json['patientID'];
    name = json['name'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['patientID'] = patientID;
    data['name'] = name;
    data['phoneNumber'] = phoneNumber;
    return data;
  }
}
