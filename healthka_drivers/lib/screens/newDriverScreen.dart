import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:healthka_drivers/datahandler/appData.dart';
import 'package:healthka_drivers/models/driver.dart';
import 'package:healthka_drivers/screens/addDocumentScreen.dart';
import 'package:healthka_drivers/widgets/allButtons.dart';
import 'package:healthka_drivers/widgets/toastMessage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class NewDriverScreen extends StatefulWidget {
  const NewDriverScreen({Key? key}) : super(key: key);

  @override
  State<NewDriverScreen> createState() => _NewDriverScreenState();
}

class _NewDriverScreenState extends State<NewDriverScreen> {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();

  File? profilePic;

  Future getImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: image.path,
          aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 50,
          maxHeight: 300,
          maxWidth: 300,
          cropStyle: CropStyle.circle,
          compressFormat: ImageCompressFormat.jpg,
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: 'Crop Picture',
                toolbarColor: Colors.redAccent,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
          ]);
      setState(() {
        if (croppedFile != null) {
          profilePic = File(croppedFile.path);
        }
      });
    }
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
            "Enter Your Details",
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Brand-Bold',
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
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(children: [
                  GestureDetector(
                    onTap: () {
                      getImage();
                    },
                    child: profilePic != null
                        ? Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 90, vertical: 30),
                            height: 150,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(100)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.file(
                                profilePic!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 90, vertical: 30),
                            height: 150,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(100)),
                            child: const Icon(
                              Icons.add_a_photo,
                              color: Colors.black45,
                            )),
                  ),
                  TextFormField(
                    controller: firstName,
                    keyboardType: TextInputType.name,
                    maxLength: 25,
                    maxLines: 1,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Colors.red[200]!,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Colors.red[300]!,
                            width: 2.0,
                          ),
                        ),
                        labelText: 'Your First Name',
                        counterText: "",
                        labelStyle: const TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 236, 83, 83)),
                        hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 245, 90, 90),
                          fontSize: 20,
                        )),
                    style: const TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: lastName,
                    keyboardType: TextInputType.name,
                    maxLength: 25,
                    maxLines: 1,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Colors.red[200]!,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Colors.red[300]!,
                            width: 2.0,
                          ),
                        ),
                        labelText: 'Your Last Name',
                        counterText: "",
                        labelStyle: const TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 236, 83, 83)),
                        hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 245, 90, 90),
                          fontSize: 20,
                        )),
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    maxLength: 40,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Colors.red[200]!,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Colors.red[300]!,
                            width: 2.0,
                          ),
                        ),
                        labelText: 'Driver Email (Optional)',
                        counterText: "",
                        labelStyle: const TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 236, 83, 83)),
                        hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 245, 90, 90),
                          fontSize: 20,
                        )),
                    style: const TextStyle(fontSize: 20),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 40, left: 60, right: 60, bottom: 10),
                    child: OvalButton(
                        title: "CONFIRM",
                        fontColor: Colors.white,
                        backgroundColor: const Color.fromARGB(255, 7, 30, 136),
                        onPressed: () async {
                          if (firstName.text.length < 2) {
                            displayToastMessage(
                                "Name must be atleast of 2 digits", context);
                          } else {
                            newDriver.driver = Driver();
                            newDriver.driver!.driverID =
                                FirebaseAuth.instance.currentUser!.uid;
                            newDriver.driver!.phoneNumber =
                                FirebaseAuth.instance.currentUser!.phoneNumber;
                            newDriver.driver!.fcmToken =
                                await FirebaseMessaging.instance.getToken();
                            newDriver.driver!.firstName = firstName.text;
                            newDriver.driver!.lastName = lastName.text;
                            newDriver.driver!.statusID = 0;
                            newDriver.driver!.profilePic = profilePic;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddDocumentScreen(),
                              ),
                            );
                          }
                        }),
                  ),
                ]),
              ],
            ),
          ),
        ));
  }
}
