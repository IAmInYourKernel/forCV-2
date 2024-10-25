import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthka_drivers/assistants/serviceAssistant.dart';
import 'package:healthka_drivers/datahandler/appData.dart';
import 'package:healthka_drivers/screens/welcomeScreen.dart';
import 'package:healthka_drivers/widgets/allButtons.dart';
import 'package:healthka_drivers/widgets/confirmSheet.dart';
import 'package:healthka_drivers/widgets/progressBar.dart';

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
                "${driver.firstName!} ${driver.lastName!}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Brand-Bold',
                  fontSize: width * 0.07,
                ),
              ),
              Text(
                "Mobile : ${driver.phoneNumber!}",
                style: TextStyle(
                  fontFamily: 'Brand-Regular',
                  fontSize: width * 0.05,
                ),
              ),
              Text(
                "Car Number : ${driver.carID!}",
                style: TextStyle(
                  fontFamily: 'Brand-Regular',
                  fontSize: width * 0.05,
                ),
              ),
              Spacer(),
              OvalButton(
                  title: "CALL OPERATOR",
                  fontColor: Colors.white,
                  backgroundColor: Colors.redAccent,

                  // Function's getting called after pressing Get Started button
                  onPressed: () async {}),
              SizedBox(
                height: 20,
              ),
              OvalButton(
                  title: "CONTACT US",
                  fontColor: Colors.white,
                  backgroundColor: Color.fromARGB(255, 41, 136, 7),

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
                                driver.statusID = 0;
                                ServiceAssistant.setDriverStatus();
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
