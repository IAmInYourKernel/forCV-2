class Customer {
  String? customerID;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? fcmToken;

  Customer();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customerID'] = customerID;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['phoneNumber'] = phoneNumber;
    data['fcmToken'] = fcmToken;
    return data;
  }

  Customer.fromJson(Map<String, dynamic> json) {
    customerID = json['customerID'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    phoneNumber = json['phoneNumber'];
    fcmToken = json['fcmToken'];
  }
}
