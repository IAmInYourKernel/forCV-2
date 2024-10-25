import 'dart:io';

class DriverDocuments {
  File? licenseBack;
  File? licenseFront;
  File? aadharBack;
  File? aadharFront;

  DriverDocuments(
      {this.aadharBack, this.aadharFront, this.licenseBack, this.licenseFront});
}
