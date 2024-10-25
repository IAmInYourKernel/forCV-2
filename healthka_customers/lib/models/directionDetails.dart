class DirectionDetails {
  late num distanceValue;
  late num durationValue;
  late String distanceText;
  late String durationText;
  late String encodedPoints;

  DirectionDetails.fromJson(Map<String, dynamic> json) {
    distanceValue = json['distanceValue'];
    durationValue = json['durationValue'];
    distanceText = json['distanceText'];
    durationText = json['durationText'];
    encodedPoints = json['encodedPoints'];
  }
}
