import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:healthka_customers/assistants/serviceAssistant.dart';
import 'package:healthka_customers/models/ambulance.dart';
import 'package:healthka_customers/models/ambulanceOrder.dart';
import 'package:healthka_customers/models/location.dart';
import 'package:healthka_customers/screens/ambulanceOrderScreen.dart';
import 'package:healthka_customers/screens/ambulanceRequestScreen.dart';
import 'package:healthka_customers/screens/ambulanceRideDetailsScreen.dart';
import 'package:healthka_customers/screens/searchPlaceScreen.dart';
import 'package:healthka_customers/widgets/allButtons.dart';
import 'package:healthka_customers/widgets/toastMessage.dart';

class AmbulanceScreen extends StatefulWidget {
  const AmbulanceScreen({super.key});

  @override
  State<AmbulanceScreen> createState() => _AmbulanceScreenState();
}

class _AmbulanceScreenState extends State<AmbulanceScreen> {
  Location? _pickUpLocation;
  Location? _dropOffLocation;

  String _pickUpAddress = "Fetcing Your Location ...";
  String _dropOffAddress = "Search Hospital";

  @override
  void initState() {
    super.initState();
    _locatePosition();
  }

  void _locatePosition() async {
    debugPrint("### GETTING CURRENT LOCATION ###");
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      _pickUpLocation = await ServiceAssistant.getCoordinateAddress(position);

      if (_pickUpLocation != null) {
        debugPrint("This is your address :: ${_pickUpLocation!.address}");
        setState(() {
          _pickUpAddress = _pickUpLocation!.address!;
        });
      }
    } catch (error) {
      debugPrint(error.toString());
      setState(() {
        _pickUpAddress = "Enter Pick Up";
      });
    }
    // }
  }

  void _searchPickUpLocation(context) async {
    var response = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => const SearchLocationScreen()));
    if (response != null) {
      setState(() {
        _pickUpLocation = response;
        _pickUpAddress = response.address;
      });
      debugPrint("THIS IS THE PICK UP LOCATION:: ${_pickUpLocation!.address}");
    }
  }

  void _searchDropOffLocation(context) async {
    var response = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => const SearchLocationScreen()));
    if (response != null) {
      setState(() {
        _dropOffLocation = response;
        _dropOffAddress = response.address;
      });
      debugPrint(
          "THIS IS THE DROP OFF LOCATION:: ${_dropOffLocation!.address}");
    }
    if (_pickUpLocation == null) {
      displayToastMessage("Please Enter Pick Up Location", context);
      _searchPickUpLocation(context);
    }
    if (_pickUpLocation != null && _dropOffLocation != null) {
      _changeToRideDetailsScreen(context);
    }
  }

  void _changeToRideDetailsScreen(context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => AmbulanceRideDeatilsScreen(
                pickUp: _pickUpLocation!,
                dropOff: _dropOffLocation!))).then((value) {
      if (value != null) {
        _changeToRequestScreen(value, context);
      }
      setState(() {
        _dropOffLocation = null;
        _dropOffAddress = "Search Hospital";
      });
    });
  }

  _changeToRequestScreen(Ambulance ambulance, context) {
    AmbulanceOrder ambulanceOrder = AmbulanceOrder();
    ambulanceOrder.ambulance = ambulance;
    ambulanceOrder.pickUp = _pickUpLocation!;
    ambulanceOrder.dropOff = _dropOffLocation!;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => AmbulanceRequestScreen(
                  ambulanceOrder: ambulanceOrder,
                ))).then((value) {
      if (value != null) {
        _changeToOrderScreen(value, context);
      }
    });
  }

  _changeToOrderScreen(orderID, context) async {
    AmbulanceOrder ambulanceOrder =
        await ServiceAssistant.getAmbulanceBookingByID(orderID);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => AmbulanceOrderScreen(
                  ambulanceOrder: ambulanceOrder,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          // Search Sheet Widget
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 20.0,
                  spreadRadius: 0.5,
                  offset: Offset(0.7, 0.7),
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Book Your Ambulance",
                      style: TextStyle(fontSize: 20, fontFamily: "Brand-Bold"),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () => _searchPickUpLocation(context),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 6.0,
                              spreadRadius: 0.5,
                              offset: Offset(0.7, 0.7),
                            )
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.home_outlined,
                                color: Color.fromARGB(255, 224, 72, 26),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(
                                  // ignore: unnecessary_null_comparison
                                  _pickUpAddress,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _searchDropOffLocation(context),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 6.0,
                              spreadRadius: 0.5,
                              offset: Offset(0.7, 0.7),
                            )
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Icon(
                                Icons.wheelchair_pickup_outlined,
                                color: Color.fromARGB(255, 33, 238, 5),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                _dropOffAddress,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
    
          // Recent Bookings Widget
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 20.0,
                  spreadRadius: 0.5,
                  offset: Offset(0.7, 0.7),
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 6,
                    ),
                    const Text(
                      "Your Recent Bookings",
                      style: TextStyle(fontSize: 20, fontFamily: "Brand-Bold"),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text("You have no recent ambulance booking"),
                  ]),
            ),
          ),
    
          // SOS Widget
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 20.0,
                  spreadRadius: 0.5,
                  offset: Offset(0.7, 0.7),
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "For Emergency Booking",
                      style: TextStyle(fontSize: 20, fontFamily: "Brand-Bold"),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    RectangularButton(
                        title: "SOS",
                        fontColor: Colors.white,
                        backgroundColor: Colors.redAccent,
                        onPressed: () {})
                  ]),
            ),
          ),
    
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 20.0,
                  spreadRadius: 0.5,
                  offset: Offset(0.7, 0.7),
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Could Not Book Ambulance ?",
                      style: TextStyle(fontSize: 20, fontFamily: "Brand-Bold"),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: RectangularButton(
                          title: "Call Us",
                          fontColor: Colors.white,
                          backgroundColor: Colors.green,
                          onPressed: () {}),
                    )
                  ]),
            ),
          ),
        ]),
      ),
    );
  }
}
