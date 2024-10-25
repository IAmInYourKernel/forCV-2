import 'package:flutter/material.dart';
import 'package:healthka_drivers/screens/otpVerificationScreen.dart';
import 'package:healthka_drivers/widgets/numericPad.dart';
import 'package:healthka_drivers/widgets/toastMessage.dart';

// Stateful class for the Login screen
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// Login Screen state
class _LoginScreenState extends State<LoginScreen> {
  // New text controller variable for mobile number
  TextEditingController mobileTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // Getting screen width and height
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    // Scaffold parent widget
    return Scaffold(
      // App bar for login screen
      appBar: AppBar(
        // Close/Button at left of appbar
        leading: GestureDetector(
          // If pressed takes back to welcome screen
          onTap: () {
            Navigator.pop(context);
          },

          // Close icon
          child: const Icon(
            Icons.close,
            size: 30,
            color: Color.fromARGB(218, 131, 19, 17),
          ),
        ),

        // Title in the appbar
        title: const Text(
          "Login with Phone",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(218, 131, 19, 17),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 243, 232, 233),
        elevation: 0,
        centerTitle: true,
      ),

      // Body of the login screen
      body: SafeArea(
          child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFFFFFF),
                    Color(0xFFF7F7F7),
                  ],
                ),
              ),
              child: Column(
                // Column to hold the logo and text
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Box to show the login screen image
                  SizedBox(
                    height: height * 0.3,
                    child: Image.asset('assets/images/login.png'),
                  ),

                  // Padding for the login text
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 64),
                    child: Text(
                      "You'll receive a 6 digit OTP to verify next.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: width * 0.055,
                        color: const Color(0xFF818181),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Container to hold the number and continue button
          Container(
            // height according to the screen size
            height: height * 0.12,
            // Making decoration of the box as white
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
            ),

            // Padding for the numbers
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    // Container size of the numbers
                    width: width * 0.5,
                    child: Column(
                      // Making left aligned numbers
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // Small leading text
                        Text(
                          "Enter your phone",
                          style: TextStyle(
                            fontSize: width * 0.04,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        // A little space
                        const SizedBox(
                          height: 8,
                        ),
                        // Row for showing the numbers
                        Row(
                          children: [
                            // Default Indian country code
                            Text(
                              "+91",
                              style: TextStyle(
                                fontSize: width * 0.05,
                                color: const Color.fromARGB(255, 109, 109, 109),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              width: 1,
                            ),
                            // Text to show the types numbers
                            Text(
                              mobileTextEditingController.text,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: width * 0.05,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),

                  // Continue Button
                  Expanded(
                    // Adding tap function
                    child: Container(
                      // decoration for the button
                      decoration: const BoxDecoration(
                        // background color of the button
                        color: Color.fromARGB(255, 7, 30, 136),
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {
                          // If number is less than 10 digits show toast
                          if (mobileTextEditingController.text.length < 10) {
                            displayToastMessage(
                                "Number must be of 10 digits", context);
                          } else {
                            // If number is of 10 digits
                            // navigate to OTP Screen
                            // and add +91 to the typed number
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OTPVerificationScreen(
                                      "+91", mobileTextEditingController.text)),
                            );
                          }
                        },
                        child: Center(
                          child: Text(
                            "CONTINUE",
                            style: TextStyle(
                              fontSize: width * 0.05,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Create Numeric Pad widget
          NumericPad(
            // If a number is pressed then
            onNumberSelected: (value) {
              // Set this -
              setState(() {
                // If value selected is a number
                if (value != -1) {
                  // If number controller length is less than 10
                  if (mobileTextEditingController.text.length < 10) {
                    // Add the current value selected to the number controller
                    mobileTextEditingController.text =
                        mobileTextEditingController.text + value.toString();
                  } else {
                    // If number is already of 10 digits
                    displayToastMessage(
                        "Number cannot be greater than 10 digits", context);
                  }
                } else {
                  // Otherwise backspace key is selected
                  mobileTextEditingController.text =
                      mobileTextEditingController.text.substring(
                          0, mobileTextEditingController.text.length - 1);
                }
              });
            },
          ),
        ],
      )),
    );
  }
}
