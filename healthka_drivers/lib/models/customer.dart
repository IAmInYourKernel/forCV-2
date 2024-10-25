class Customer {
  String? customerID;
  String? name;
  String? phoneNumber;

  Customer.fromJson(Map<String, dynamic> json) {
    customerID = json['customerID'];
    name = json['name'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customerID'] = customerID;
    data['name'] = name;
    data['phoneNumber'] = phoneNumber;
    return data;
  }
}
