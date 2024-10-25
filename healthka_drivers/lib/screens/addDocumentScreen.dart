import 'dart:io';

import 'package:flutter/material.dart';
import 'package:healthka_drivers/assistants/serviceAssistant.dart';
import 'package:healthka_drivers/datahandler/appData.dart';
import 'package:healthka_drivers/models/driver.dart';
import 'package:healthka_drivers/models/driverDocuments.dart';
import 'package:healthka_drivers/screens/addAmbulanceScreen.dart';
import 'package:healthka_drivers/screens/mainScreen.dart';
import 'package:healthka_drivers/widgets/allButtons.dart';
import 'package:healthka_drivers/widgets/progressBar.dart';
import 'package:image_picker/image_picker.dart';

class AddDocumentScreen extends StatefulWidget {
  const AddDocumentScreen({super.key});

  @override
  State<AddDocumentScreen> createState() => _AddDocumentScreenState();
}

class _AddDocumentScreenState extends State<AddDocumentScreen> {
  File? licenseFront;
  File? licenseBack;
  File? aadharCardFront;
  File? aadharCardBack;

  Future getLicenseFront() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      licenseFront = File(image!.path);
    });
  }

  Future getLicenseBack() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      licenseBack = File(image!.path);
    });
  }

  Future getAadharFront() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      aadharCardFront = File(image!.path);
    });
  }

  Future getAadharBack() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      aadharCardBack = File(image!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.close,
              size: 30,
              color: Color.fromARGB(218, 131, 19, 17),
            ),
          ),
          title: const Text(
            "Enter Driver Documents",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(218, 131, 19, 17),
            ),
          ),
          backgroundColor: Colors.red[100],
          elevation: 0,
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.red[300]!),
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Upload License\nFront Image",
                        style: TextStyle(fontSize: 20, color: Colors.red[600]),
                      ),
                      Expanded(child: Container()),
                      GestureDetector(
                        onTap: () {
                          getLicenseFront();
                        },
                        child: licenseFront != null
                            ? Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(100)),
                                child: Icon(
                                  Icons.check_circle_outline_outlined,
                                  color: Colors.green[800],
                                  size: 40,
                                ))
                            : Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(100)),
                                child: const Icon(
                                  Icons.add_a_photo,
                                  color: Colors.black45,
                                )),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.red[300]!),
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Upload License\nBack Image",
                        style: TextStyle(fontSize: 20, color: Colors.red[600]),
                      ),
                      Expanded(child: Container()),
                      GestureDetector(
                        onTap: () {
                          getLicenseBack();
                        },
                        child: licenseBack != null
                            ? Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(100)),
                                child: Icon(
                                  Icons.check_circle_outline_outlined,
                                  color: Colors.green[800],
                                  size: 40,
                                ))
                            : Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(100)),
                                child: const Icon(
                                  Icons.add_a_photo,
                                  color: Colors.black45,
                                )),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 40, left: 60, right: 60, bottom: 10),
                  child: OvalButton(
                      title: "CONTINUE",
                      fontColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 7, 30, 136),
                      onPressed: () async {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) => CircularProgress(
                                  status: "Uploading your documents",
                                ));
                        newDriver.driverDocuments = DriverDocuments(
                            licenseFront: licenseFront,
                            licenseBack: licenseBack,
                            aadharFront: aadharCardFront,
                            aadharBack: aadharCardBack);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddAmbulanceScreen(),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
        ));
  }
}
