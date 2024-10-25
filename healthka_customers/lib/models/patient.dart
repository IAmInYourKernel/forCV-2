class Patient {
  String? patientID;
  String? firstName;
  String? lastName;
  String? dateOfBirth;
  String? age;
  String? note;

  Patient();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['patientID'] = patientID;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['dateOfBirth'] = dateOfBirth;
    data['age'] = age;
    data['note'] = note;
    return data;
  }

  Patient.fromJson(Map<String, dynamic> json) {
    patientID = json['patientID'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    dateOfBirth = json['dateOfBirth'];
    age = json['age'];
    note = json['note'];
  }
}
