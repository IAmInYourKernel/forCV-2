// import 'package:ambudoor_rider/AllScreens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:healthka_drivers/datahandler/appData.dart';
import 'package:healthka_drivers/screens/loginScreen.dart';
import 'package:healthka_drivers/widgets/allButtons.dart';
import 'package:permission_handler/permission_handler.dart';

// Stateful Class for the welcome screen
class WelcomeScreen extends StatefulWidget {
  // Named route
  static const String idScreen = "welcome";
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

// Welcome Screen state
class _WelcomeScreenState extends State<WelcomeScreen> {
  _handlePermissions() async {
    // Create Notification Channels
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(importantNotiChannel);
    // Variable asking location permission
    PermissionStatus status = await Permission.location.request();
    if (status == PermissionStatus.granted) {
      // Continue to Login Screen page
      // ignore: use_build_context_synchronously
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
    } else {
      // If permission not given show dialog again to allow permission from settings
      // ignore: use_build_context_synchronously
      showDialog(
          // Dialog on the same context page
          context: context,
          // Build an alert dialog
          builder: (BuildContext context) => AlertDialog(
                // Title and content of the location permission alert box
                title: const Text("Location Permission"),
                content: const Text(
                    "This app needs live location access to book ambulance"),
                actions: [
                  // Deny button
                  TextButton(
                      // If Deny pressed close the alert box but stay in welcome screen
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Deny",
                        style: TextStyle(fontSize: 20),
                      )),

                  // Open settings button
                  TextButton(
                      // If Open settings pressed, then open permission settings of the app
                      onPressed: () => openAppSettings(),
                      child: const Text(
                        "Open Settings",
                        style: TextStyle(fontSize: 20),
                      ))
                ],
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Getting screen width and height
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    // Scaffold Parent Widget
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 244, 244),
      body: Padding(
        // Adding main padding for all widget
        padding: const EdgeInsets.all(8),

        // Inserting Widgets in Column
        child: Column(children: [
          // Widget to hold logo and name
          Container(
            alignment: Alignment.center,
            height: height * 0.7,
            child: Column(
              // centred columnn child
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,

              // children inside the column
              children: [
                // Logo Image
                Image(
                  image: const AssetImage('assets/images/logo.png'),
                  height: height * (0.35),
                  width: width * (0.8),
                ),
                // Tag Line of Company
                Text(
                  "Apka HealthKa Assistant",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Brand-Bold',
                      fontSize: width * 0.07,
                      color: const Color.fromARGB(255, 228, 29, 15)),
                ),
              ],
            ),
          ),

          // spacer widget to place next button at the bottom
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Text widget for T&C (Should be linked to website t&c page)
                const Text(
                  "By clicking on below button, you are agreeing to our terms and conditions",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 73, 133),
                      fontFamily: 'Brand',
                      fontStyle: FontStyle.italic),
                ),
                const SizedBox(
                  height: 20,
                ),

                // Button to continue to login page
                OvalButton(
                    title: "GET STARTED",
                    fontColor: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 7, 30, 136),

                    // Function's getting called after pressing Get Started button
                    onPressed: () async {
                      await _handlePermissions();
                    }),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
