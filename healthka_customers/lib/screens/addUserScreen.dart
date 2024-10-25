import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:healthka_customers/assistants/serviceAssistant.dart';
import 'package:healthka_customers/screens/mainScreen.dart';
import 'package:healthka_customers/screens/welcomeScreen.dart';

import 'package:healthka_customers/widgets/allButtons.dart';
import 'package:healthka_customers/widgets/progressBar.dart';
import 'package:healthka_customers/widgets/toastMessage.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({Key? key}) : super(key: key);

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () async {
              debugPrint("SIGNING OUT");
              await FirebaseAuth.instance.signOut();
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
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(children: [
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
                        labelText: 'First Name',
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
                        labelText: 'Last Name (Optional)',
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
                            // Add CrudMethods
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) =>
                                    CircularProgress(
                                      status: "Signing Up....",
                                    ));
                            await ServiceAssistant.createNewCustomer(
                                    FirebaseAuth.instance.currentUser!.uid,
                                    FirebaseAuth
                                        .instance.currentUser!.phoneNumber
                                        .toString(),
                                    firstName.text,
                                    lastName.text,
                                    (await FirebaseMessaging.instance
                                            .getToken())
                                        .toString())
                                .then((value) {
                              if (value) {
// ignore: use_build_context_synchronously
                                Navigator.pushNamedAndRemoveUntil(context,
                                    MainScreen.idScreen, (route) => false);
                              } else {
                                displayToastMessage(
                                    "Error Signing Up", context);
                                Navigator.pushNamedAndRemoveUntil(context,
                                    WelcomeScreen.idScreen, (route) => false);
                              }
                            });
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
