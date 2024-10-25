class Fare {
  num? value;
  String? currency;

  Fare({required this.value, required this.currency});

  Fare.fromJson(Map<String, dynamic> json) {
    currency = json['currency'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['currency'] = currency;
    data['value'] = value;
    return data;
  }
}
