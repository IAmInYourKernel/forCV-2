class PlacePrediction {
  late String placeID;
  late String mainText;
  late String secondaryText;

  PlacePrediction.fromJson(Map<String, dynamic> json) {
    placeID = json["placeID"];
    mainText = json["mainText"];
    secondaryText = json["secondaryText"];
  }
}
