import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:healthka_customers/datahandler/appData.dart';
import 'package:healthka_customers/screens/welcomeScreen.dart';
import 'package:healthka_customers/widgets/allButtons.dart';
import 'package:healthka_customers/widgets/confirmSheet.dart';
import 'package:healthka_customers/widgets/progressBar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Getting screen width and height
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 248, 244, 244),
        body: Padding(
          // Adding main padding for all widget
          padding: const EdgeInsets.all(20),

          // Inserting Widgets in Column
          child: Column(
            // centred columnn child
            // mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.person_4_rounded,
                size: width * 0.5,
              ),
              Text(
                "${customer.firstName!} ${customer.lastName!}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Brand-Bold',
                  fontSize: width * 0.07,
                ),
              ),
              Text(
                "Mobile : ${customer.phoneNumber!}",
                style: TextStyle(
                  fontFamily: 'Brand-Regular',
                  fontSize: width * 0.05,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: RectangularButton(
                    title: "EDIT PROFILE",
                    fontColor: Colors.white,
                    backgroundColor: Colors.green,

                    // Function's getting called after pressing Get Started button
                    onPressed: () async {}),
              ),
              Spacer(),
              OvalButton(
                  title: "CONTACT US",
                  fontColor: Colors.white,
                  backgroundColor: Colors.redAccent,

                  // Function's getting called after pressing Get Started button
                  onPressed: () async {}),
              SizedBox(
                height: 20,
              ),
              OvalButton(
                  title: "SIGN OUT",
                  fontColor: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 7, 30, 136),

                  // Function's getting called after pressing Get Started button
                  onPressed: () async {
                    showModalBottomSheet(
                        context: context,
                        isDismissible: false,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25))),
                        builder: (BuildContext context) => ConfirmSheet(
                              heading: "SIGN OUT",
                              message: "Are you sure you want to Sign Out?",
                              cancelButtonMessage: "No",
                              chooseButtonMessage: "Yes",
                              chooseButtonColor: Colors.redAccent,
                              cancelButtonFunction: () {
                                Navigator.pop(context);
                              },
                              chooseButtonFunction: () async {
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) =>
                                        CircularProgress(
                                          status: "Logging Out...",
                                        ));
                                
                                await FirebaseAuth.instance.signOut();
                                debugPrint("USER IS SIGNED OUT");
                                Navigator.pushNamedAndRemoveUntil(context,
                                    WelcomeScreen.idScreen, (route) => false);
                              },
                            ));
                  }),
            ],
          ),
        ));
  }
}
