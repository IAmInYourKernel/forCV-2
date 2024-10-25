import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthka_customers/assistants/localServiceAssistant.dart';
import 'package:healthka_customers/assistants/notificationAssistant.dart';
import 'package:healthka_customers/assistants/serviceAssistant.dart';
import 'package:healthka_customers/datahandler/appData.dart';
import 'package:healthka_customers/datahandler/cartProvider.dart';
import 'package:healthka_customers/screens/mainScreen.dart';
import 'package:healthka_customers/screens/welcomeScreen.dart';
import 'package:healthka_customers/transferToMain/Model/ProviderModel.dart';
import 'package:provider/provider.dart';

// Variable to store the opening route/page
// ignore: prefer_typing_uninitialized_variables
var route;

// Main function of the app
void main() async {
  // Initialize Flutter
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp();
  NotificationAssistant.initializeFirebaseMessagingServices();
  db = await LocalServiceAssistant.connectLocalDB();
  // Check if user is logged in
  if (FirebaseAuth.instance.currentUser == null) {
    // If user is not logged in
    debugPrint('User is currently signed out!');
    // Set route to welcome screen
    route = WelcomeScreen.idScreen;
    // // Start the MyApp state
  } else {
    var customerID = FirebaseAuth.instance.currentUser!.uid;
    debugPrint(customerID);
    if (await ServiceAssistant.checkNewCustomer(customerID) == true) {
      debugPrint('User is signed in but not registered!');
      await FirebaseAuth.instance.signOut();
      // route = WelcomeScreen.idScreen;
      route = WelcomeScreen.idScreen;
    } else {
      // If user is logged in
      debugPrint('User is signed in!');
      // Set route to mainscreen
      route = MainScreen.idScreen;
    }
  }
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Color.fromARGB(191, 2, 2, 2)));
  runApp(
    ChangeNotifierProvider(
      create: (_) => dataListProvider(),
      child: MyApp(),
    ),
  );
}

// Class for the MyApp
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of the application.

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

// State for the MyApp
class _MyAppState extends State<MyApp> {
  // Main Widget
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: route,
      // Routes for the app
      routes: {
        WelcomeScreen.idScreen: (context) => const MainScreen(),
        MainScreen.idScreen: (context) => const MainScreen()
      },
    );
  }
}
