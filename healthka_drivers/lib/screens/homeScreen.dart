import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:healthka_drivers/assistants/serviceAssistant.dart';
import 'package:healthka_drivers/datahandler/appData.dart';
import 'package:healthka_drivers/widgets/allButtons.dart';
import 'package:healthka_drivers/widgets/confirmSheet.dart';
import 'package:healthka_drivers/widgets/progressBar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;

  Color _onlineIndexButtonColor = driver.statusID == 0
      ? Colors.grey
      : driver.statusID == 1
          ? Colors.green
          : Colors.redAccent;
  String _onlineIndexText = driver.statusID == 0
      ? "Offline"
      : driver.statusID == 1
          ? "Online"
          : "On Ride";

  String currentAddress = driver.statusID == 0
      ? "You are offline"
      : driver.statusID == 1
          ? "Getting Current Location .."
          : "Driver Busy";

  Icon onLocation = const Icon(
    Icons.location_on,
    color: Colors.greenAccent,
  );
  Icon offLocation = const Icon(
    Icons.location_off,
    color: Colors.redAccent,
  );
  Icon locationIcon = driver.statusID == 0 || driver.statusID == 2
      ? const Icon(
          Icons.location_off,
          color: Colors.redAccent,
        )
      : const Icon(
          Icons.location_on,
          color: Colors.greenAccent,
        );

  // Changes the top bar index
  _changeOnlineIndex(context) async {
    await showModalBottomSheet(
        context: context,
        isDismissible: false,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        builder: (BuildContext context) => ConfirmSheet(
              heading: "Change Status",
              message: driver.statusID == 0
                  ? "Are you sure you want to be Online"
                  : "Are you sure you want to be Offline",
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
                    builder: (BuildContext context) => CircularProgress(
                          status: "Changing Status",
                        ));
                // If offline - Change to online
                if (driver.statusID == 0) {
                  setState(() {
                    driver.statusID = 1;
                    _onlineIndexButtonColor = Colors.green;
                    locationIcon = onLocation;
                    _onlineIndexText = "Online";
                    currentAddress = "Getting Current Location ..";
                  });
                  _locatePosition();
                }
                // If online - Change to offline
                else {
                  setState(() {
                    driver.statusID = 0;
                    _onlineIndexButtonColor = Colors.grey;
                    _onlineIndexText = "Offline";
                    locationIcon = offLocation;
                    currentAddress = "You are offline";
                  });
                }
                await ServiceAssistant.setDriverStatus();
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ));
  }

  void _locatePosition() async {
    debugPrint("### GETTING CURRENT LOCATION ###");
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      driver.loc = await ServiceAssistant.getCoordinateAddress(position);

      if (driver.loc != null) {
        debugPrint("This is your address :: ${driver.loc!.address}");
        setState(() {
          currentAddress = driver.loc!.address!;
        });
      }
      await ServiceAssistant.updateCurrentLocation();
    } catch (error) {
      debugPrint(error.toString());
      setState(() {
        currentAddress = "Enter Current Location";
      });
    }
  }

  void _getDriverDetails() async {
    await ServiceAssistant.checkNewDriver(driver.driverID);
    setState(() {
      isLoading = false;
    });
    if (driver.statusID == 1) {
      _locatePosition();
    }
  }

  @override
  void initState() {
    super.initState();
    _getDriverDetails();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: isLoading
          ? const CircularProgressIndicator() // Show loading indicator while waiting for API response
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  color: const Color.fromARGB(191, 2, 2, 2),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 70),
                    child: OvalButton(
                        title: _onlineIndexText,
                        fontColor: Colors.white,
                        backgroundColor: _onlineIndexButtonColor,
                        onPressed: () {
                          if (driver.statusID != 2) {
                            _changeOnlineIndex(context);
                          }
                        }),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 18),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Your Location",
                            style: TextStyle(
                                fontSize: 20, fontFamily: "Brand-Bold"),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            // margin: const EdgeInsets.only(bottom: 15),
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
                            child: TextButton(
                              onPressed: () => {},
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Row(
                                  children: [
                                    locationIcon,
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Text(
                                        // ignore: unnecessary_null_comparison
                                        currentAddress,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
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
              ],
            ),
    );
  }
}
