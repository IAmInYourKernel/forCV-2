import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthka_customers/assistants/serviceAssistant.dart';
import 'package:healthka_customers/screens/addUserScreen.dart';
import 'package:healthka_customers/screens/mainScreen.dart';
import 'package:healthka_customers/widgets/progressBar.dart';
import 'package:pinput/pinput.dart';

// ignore: camel_case_types
class OTPVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String phoneCountryCode;

  const OTPVerificationScreen(this.phoneCountryCode, this.phoneNumber,
      {super.key});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final TextEditingController _OTPcontroller = TextEditingController();
  late String _phoneVerficationCode;
  late String _phoneOTPCode;
  bool _resendButtonVisible = false;
  final Duration _otpTimer = const Duration(seconds: 15);

  verifyPhoneNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '${widget.phoneCountryCode}${widget.phoneNumber}',
      verificationCompleted: (PhoneAuthCredential credential) async {
        debugPrint("### PHONENUMBER ENTERED IS VALID ###");
      },
      verificationFailed: (FirebaseAuthException e) {
        debugPrint("### PHONENUMBER ENTERED IS INVALID ###");
        debugPrint("ERROR :: ${e.message}");
      },
      codeSent: (String verficationId, int? resendToken) {
        startTimer();
        if (mounted) {
          setState(() {
            _phoneVerficationCode = verficationId;
          });
        }
      },
      codeAutoRetrievalTimeout: (String verficationId) {
        if (mounted) {
          setState(() {
            _phoneVerficationCode = verficationId;
          });
        }
      },
      timeout: _otpTimer,
    );
  }

  verifyOTP() async {
    try {
      // wait for firebase to authenticate the verification code
      await FirebaseAuth.instance
          .signInWithCredential(PhoneAuthProvider.credential(
              verificationId: _phoneVerficationCode, smsCode: _phoneOTPCode))
          .then((value) async {
        if (value.user != null) {
          debugPrint("### OTP AUTHENTICATION SUCCESSFUL ###");
          debugPrint("### SIGN IN SUCCESSFUL ###");
          return true;
        } else {
          debugPrint("### OTP AUTHENTICATION SUCCESSFUL ###");
          debugPrint("### SIGN IN UNSUCCESSFUL ###");
          return false;
        }
      });
    } catch (e) {
      debugPrint("### OTP AUTHENTICATION UNSUCCESSFUL ###");
      debugPrint("### SIGN IN UNSUCCESSFUL ###");
      // If OTP is invalid clear the OTP screen
      return false;
    }
    return true;
  }

  startTimer() {
    debugPrint("### STARTING TIMER ###");
    Timer(_otpTimer, () {
      if (mounted) {
        setState(() {
          _resendButtonVisible = true;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    verifyPhoneNumber();
  }

  @override
  void dispose() {
    // ignore: avoid_print
    print('### DISPOSE USED ###');
    _OTPcontroller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Setting the color vars
    const focusedBorderColor = Color.fromARGB(255, 7, 30, 136);
    const fillColor = Color.fromARGB(255, 255, 255, 255);
    const borderColor = Color.fromARGB(255, 230, 129, 129);

    // Setting the screen size vars
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    // Setting the pin theme
    final defaultPinTheme = PinTheme(
      // Width and height of the pin box
      width: 56,
      height: 56,
      textStyle: GoogleFonts.poppins(
        fontSize: 22,
        color: const Color.fromARGB(204, 30, 60, 87),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: borderColor),
        color: Colors.white,
        boxShadow: const <BoxShadow>[
          BoxShadow(
              color: Colors.black26,
              blurRadius: 15.0,
              spreadRadius: 0.5,
              offset: Offset(0.0, 0.75))
        ],
      ),
    );

    // Parent widget of the screen
    return Scaffold(
        appBar: AppBar(
          // Back button in the app bar
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 25,
              color: Color.fromARGB(218, 131, 19, 17),
            ),
          ),
          // Title in the app bar
          title: const Text(
            "Verify Phone",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(218, 131, 19, 17),
            ),
          ),
          backgroundColor: const Color.fromRGBO(243, 232, 233, 1),
          elevation: 0,
          centerTitle: true,
        ),
        backgroundColor: const Color.fromARGB(255, 248, 244, 244),
        // Body of the screen
        body: SingleChildScrollView(
          // Padding every side of the screen
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(children: [
                // Box holding OTP image
                SizedBox(
                  height: height * 0.3,
                  child: Image.asset('assets/images/otp2.png'),
                ),
                const SizedBox(
                  height: 10,
                ),
                // Row for showing phone number otp has been sent to
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("OTP is sent to ",
                        style: TextStyle(
                            fontFamily: 'Brand',
                            fontSize: width * 0.055,
                            color: const Color(0xFF818181))),
                    GestureDetector(
                      // If number pressed navigate back to login page
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Row(children: [
                        Text(widget.phoneCountryCode + widget.phoneNumber,
                            style: TextStyle(
                                fontFamily: 'Brand',
                                decoration: TextDecoration.underline,
                                fontSize: width * 0.055,
                                color: const Color(0xFF818181))),
                        Icon(
                          Icons.mode_edit_outline_outlined,
                          size: width * 0.055,
                        )
                      ]),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                // Widget to show the OTP boxes
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  // Giving pinput theme
                  child: Pinput(
                    controller: _OTPcontroller,
                    autofocus: true,
                    length: 6,
                    // Auto fill from sms enabled
                    androidSmsAutofillMethod:
                        AndroidSmsAutofillMethod.smsRetrieverApi,
                    // If all the boxes are filled
                    onCompleted: (pin) async {
                      // Show dialog box
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) => CircularProgress(
                                status: "Verifying OTP...",
                              ));
                      // Checking if the otp is correct
                      if (mounted) {
                        setState(() {
                          _phoneOTPCode = pin;
                        });
                      }
                      if (await verifyOTP()) {
                        if (await ServiceAssistant.checkNewCustomer(
                                FirebaseAuth.instance.currentUser!.uid) ==
                            true) {
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AddUserScreen()));
                        } else {
                          // ignore: use_build_context_synchronously
                          Navigator.pushNamedAndRemoveUntil(
                              context, MainScreen.idScreen, (route) => false);
                        }
                      } else {
                        _OTPcontroller.clear();
                        // Unfocus the OTP box
                        FocusScope.of(context).unfocus();
                        Navigator.pop(context);
                      }
                    },
                    listenForMultipleSmsOnAndroid: true,
                    defaultPinTheme: defaultPinTheme,
                    // Get OTP from clipboard
                    onClipboardFound: (value) {
                      debugPrint('onClipboardFound: $value');
                      _OTPcontroller.setText(value);
                    },
                    hapticFeedbackType: HapticFeedbackType.lightImpact,
                    cursor: Column(
                      // Giving design to the OTP Box Border
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 9),
                          width: 22,
                          height: 1,
                          color: focusedBorderColor,
                        ),
                      ],
                    ),
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: focusedBorderColor, width: 2),
                      ),
                    ),
                    submittedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        color: fillColor,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: focusedBorderColor, width: 2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                // Text for showing autodetecting
                Visibility(
                  maintainSize: false,
                  maintainAnimation: false,
                  maintainState: true,
                  visible: !_resendButtonVisible,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/loading.gif",
                        height: 20.0,
                        width: 20.0,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text("Auto-Detecting Incoming OTP",
                          style: TextStyle(
                              // fontFamily: 'Brand',
                              fontSize: 15,
                              color: Color(0xFF818181)))
                    ],
                  ),
                ),
                // Text showing request OTP again
                Visibility(
                  maintainSize: false,
                  maintainAnimation: false,
                  maintainState: true,
                  visible: _resendButtonVisible,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Didn't receive OTP? ",
                          style: TextStyle(
                              // fontFamily: 'Brand',
                              fontSize: 15,
                              color: Color(0xFF818181))),
                      GestureDetector(
                        onTap: () {
                          if (mounted) {
                            setState(() {
                              _resendButtonVisible = false;
                            });
                            verifyPhoneNumber();
                          }
                        },
                        child: Text("Request again",
                            style: TextStyle(
                                fontSize: 15,
                                decoration: TextDecoration.underline,
                                color: const Color.fromARGB(255, 126, 78, 78))),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ));
  }
}
