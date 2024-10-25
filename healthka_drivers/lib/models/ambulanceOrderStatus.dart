class AmbulanceOrderStatus {
  num? statusID;
  String? status;

  AmbulanceOrderStatus.fromJson(Map<String, dynamic> json) {
    statusID = json['statusID'];
    status = json["status"];
  }
}
