class AmbulanceOrderStatus {
  num? statusID;
  String? status;

  AmbulanceOrderStatus();

  AmbulanceOrderStatus.fromJson(Map<String, dynamic> json) {
    statusID = json['statusID'];
    status = json["status"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusID'] = statusID;
    data['status'] = status;
    return data;
  }
}
