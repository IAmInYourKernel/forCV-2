import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:healthka_drivers/assistants/serviceAssistant.dart';
import 'package:healthka_drivers/datahandler/appData.dart';
import 'package:healthka_drivers/datahandler/serverData.dart';
import 'package:healthka_drivers/models/ambulanceOrder.dart';
import 'package:healthka_drivers/models/ambulanceOrderStatus.dart';
import 'package:healthka_drivers/models/fare.dart';
import 'package:healthka_drivers/widgets/allButtons.dart';
import 'package:url_launcher/url_launcher.dart';

class RideScreen extends StatefulWidget {
  AmbulanceOrder ambulanceOrder;
  static const String idScreen = "rideScreen";
  RideScreen(this.ambulanceOrder, {super.key});

  @override
  State<RideScreen> createState() => _RideScreenState();
}

class _RideScreenState extends State<RideScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  late GoogleMapController _newController;

  Set<Marker> markersSet = {};
  Set<Polyline> polylineSet = {};

  _setMarkers() async {
    markersSet.clear();
    Marker pickUpLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      markerId: const MarkerId("pickUpMarker"),
      position: LatLng(
          widget.ambulanceOrder.pickUp!.lat, widget.ambulanceOrder.pickUp!.lng),
    );
    Marker dropOffLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      markerId: const MarkerId("dropOffMarker"),
      position: LatLng(widget.ambulanceOrder.dropOff!.lat,
          widget.ambulanceOrder.dropOff!.lng),
    );
    Marker currentLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      markerId: const MarkerId("currentMarker"),
      position: LatLng(widget.ambulanceOrder.currentLoc!.lat,
          widget.ambulanceOrder.currentLoc!.lng),
    );
    if (widget.ambulanceOrder.status!.statusID == 1) {
      setState(() {
        markersSet.add(currentLocMarker);
        markersSet.add(pickUpLocMarker);
      });
    } else if (widget.ambulanceOrder.status!.statusID == 2) {
      setState(() {
        markersSet.add(currentLocMarker);
        markersSet.add(dropOffLocMarker);
      });
    }
  }

  // _setPolyLines() async {
  //   PolylinePoints polylinePoints = PolylinePoints();
  //   late DirectionDetails directionDetails;
  //   if (widget.widget.ambulanceOrder.statusID == 1) {
  //     directionDetails = await ServiceAssistant.getDirectionDetails(
  //         widget.widget.ambulanceOrder.currentLoc!, widget.widget.ambulanceOrder.pickUp!);
  //   } else if (widget.widget.ambulanceOrder.statusID == 2) {
  //     directionDetails = await ServiceAssistant.getDirectionDetails(
  //         widget.widget.ambulanceOrder.currentLoc!, widget.widget.ambulanceOrder.dropOff!);
  //   }

  //   List<PointLatLng> decodedPolyLinePointsResult =
  //       polylinePoints.decodePolyline(directionDetails.encodedPoints);

  //   List<LatLng> pLineCoordinates = [];
  //   if (decodedPolyLinePointsResult.isNotEmpty) {
  //     for (PointLatLng pointLatLng in decodedPolyLinePointsResult) {
  //       pLineCoordinates
  //           .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
  //     }
  //   }
  //   polylineSet.clear();
  //   setState(() {
  //     Polyline polyline = Polyline(
  //       color: const Color.fromARGB(255, 233, 80, 10),
  //       polylineId: const PolylineId("PolylineID"),
  //       jointType: JointType.round,
  //       points: pLineCoordinates,
  //       width: 5,
  //       startCap: Cap.roundCap,
  //       endCap: Cap.roundCap,
  //       geodesic: true,
  //     );
  //     polylineSet.add(polyline);
  //   });
  // }

  _animateCameraToNavigation() async {
    LatLngBounds latLngBounds;
    late LatLng pickUpLatLng;
    late LatLng dropOffLatLng;
    if (widget.ambulanceOrder.status!.statusID == 1) {
      pickUpLatLng = LatLng(widget.ambulanceOrder.currentLoc!.lat,
          widget.ambulanceOrder.currentLoc!.lng);
      dropOffLatLng = LatLng(
          widget.ambulanceOrder.pickUp!.lat, widget.ambulanceOrder.pickUp!.lng);
    } else if (widget.ambulanceOrder.status!.statusID == 2) {
      pickUpLatLng = LatLng(widget.ambulanceOrder.currentLoc!.lat,
          widget.ambulanceOrder.currentLoc!.lng);
      dropOffLatLng = LatLng(widget.ambulanceOrder.dropOff!.lat,
          widget.ambulanceOrder.dropOff!.lng);
    }

    if (pickUpLatLng.latitude > dropOffLatLng.latitude &&
        pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds = LatLngBounds(
        southwest: dropOffLatLng,
        northeast: pickUpLatLng,
      );
    } else if (pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds = LatLngBounds(
        southwest: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude),
        northeast: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude),
      );
    } else if (pickUpLatLng.latitude > dropOffLatLng.latitude) {
      latLngBounds = LatLngBounds(
        southwest: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude),
        northeast: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude),
      );
    } else {
      latLngBounds =
          LatLngBounds(southwest: pickUpLatLng, northeast: dropOffLatLng);
    }
    await _newController
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 25));
  }

  _startLiveOrderStream() async {
    await ServiceAssistant.connectToOrderChannel();
    await ServiceAssistant.getOrderUpdatesDriver(widget.ambulanceOrder.orderID);
    ongoingRideChannel!.stream.listen((response) {
      print(response);
      response = jsonDecode(response);
      if (response['resSuccess'] == 1) {
        var data = response['data'];
        var event = response['event'];
        if (event == "getOrderUpdatesDriver") {
          if (widget.ambulanceOrder.status!.statusID !=
              data['orderStatus']['statusID']) {
            setState(() {
              widget.ambulanceOrder.status =
                  AmbulanceOrderStatus.fromJson(data['orderStatus']);
            });
            _setMarkers();
            _animateCameraToNavigation();
          }
        } else if (event == "patientPickedUp") {
          setState(() {
            widget.ambulanceOrder.status =
                AmbulanceOrderStatus.fromJson(data['orderStatus']);
          });
          _setMarkers();
          _animateCameraToNavigation();
        } else if (event == "destinationReached") {
          setState(() {
            widget.ambulanceOrder.status =
                AmbulanceOrderStatus.fromJson(data['orderStatus']);
            widget.ambulanceOrder.actualFare = Fare.fromJson(data['fare']);
          });
        } else if (event == "paymentDone") {
          setState(() {
            widget.ambulanceOrder.status =
                AmbulanceOrderStatus.fromJson(data['orderStatus']);
            driver.statusID = 1;
          });
          Navigator.pop(context);
        }
      }
    });
  }

  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.bestForNavigation,
    distanceFilter: 100,
  );
  @override
  void initState() {
    super.initState();
    _startLiveOrderStream();

    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      setState(() {
        widget.ambulanceOrder.currentLoc!.lat = position!.latitude;
        widget.ambulanceOrder.currentLoc!.lng = position.longitude;
      });
      ServiceAssistant.setCurrentLocation(
          widget.ambulanceOrder.orderID, widget.ambulanceOrder.currentLoc!);
      _setMarkers();
      _animateCameraToNavigation();
    });
  }

  @override
  void dispose() {
    debugPrint("DISPOSE CALLED FOR ORDER DETAILS SCREEN");
    ongoingRideChannel!.sink.close();
    _controller.future.then((value) => value.dispose());
    _newController.dispose();
    super.dispose();
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
            Icons.arrow_back_ios_new_rounded,
            size: 25,
            color: Colors.white,
          ),
        ),
        title: const Text(
          "Booking Status",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(191, 2, 2, 2),
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(children: [
        // Google Map Screen
        Visibility(
          visible: (widget.ambulanceOrder.status!.statusID == 1 ||
              widget.ambulanceOrder.status!.statusID == 2),
          child: GoogleMap(
              mapType: MapType.normal,
              padding: EdgeInsets.only(bottom: 250),
              initialCameraPosition: CameraPosition(
                  target: LatLng(widget.ambulanceOrder.pickUp!.lat,
                      widget.ambulanceOrder.pickUp!.lng),
                  zoom: 18),
              onMapCreated: (GoogleMapController controller) async {
                _controller.complete(controller);
                _newController = controller;
                await _setMarkers();
                Future.delayed(const Duration(milliseconds: 1000), () {
                  _animateCameraToNavigation();
                });
              },
              markers: markersSet,
              polylines: polylineSet,
              zoomControlsEnabled: false,
              rotateGesturesEnabled: false,
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
              compassEnabled: false,
              mapToolbarEnabled: false,
              buildingsEnabled: false),
        ),

        // Payment Screen
        Visibility(
          visible: (widget.ambulanceOrder.status!.statusID == 3),
          child: Scaffold(
            body: Center(
              child: Column(
                children: [
                  Text("Collect Cash"),
                  Text((widget.ambulanceOrder.actualFare!.value).toString()),
                  OvalButton(
                      title: "Payment Collected",
                      fontColor: Colors.white,
                      backgroundColor: Colors.black,
                      onPressed: () async {
                        await ServiceAssistant.paymentDone(
                            widget.ambulanceOrder.orderID);
                      })
                ],
              ),
            ),
          ),
        ),

        // Navigate Button
        Visibility(
          visible: (widget.ambulanceOrder.status!.statusID != 3),
          child: Positioned(
            top: 50,
            child: RectangularButton(
              fontColor: Colors.white,
              backgroundColor: Colors.blueAccent,
              onPressed: () {
                var url = "";
                if (widget.ambulanceOrder.status!.statusID == 1) {
                  url =
                      'https://www.google.com/maps/dir/?api=1&destination=${widget.ambulanceOrder.pickUp!.lat},${widget.ambulanceOrder.pickUp!.lng}';
                } else if (widget.ambulanceOrder.status!.statusID == 2) {
                  url =
                      'https://www.google.com/maps/dir/?api=1&destination=${widget.ambulanceOrder.dropOff!.lat},${widget.ambulanceOrder.dropOff!.lng}';
                }
                launchUrl(Uri.parse(url));
              },
              title: 'Navigate',
            ),
          ),
        ),

        // Ride Confirmed Sheet
        Visibility(
          visible: (widget.ambulanceOrder.status!.statusID == 1),
          child: Positioned(
            left: 10,
            right: 10,
            bottom: 10,
            child: Container(
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      const Text(
                        "Towards Patient",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontFamily: 'Brand-Bold', fontSize: 22),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Divider(),
                      const SizedBox(
                        height: 10,
                      ),
                      RectangularButton(
                          title: "Call Patient",
                          fontColor: Colors.white,
                          backgroundColor: Colors.blueAccent,
                          onPressed: () {}),
                      const SizedBox(
                        height: 10,
                      ),
                      RectangularButton(
                          title: "Patient Picked Up",
                          fontColor: Colors.white,
                          backgroundColor: Colors.blueAccent,
                          onPressed: () async {
                            await ServiceAssistant.patientPickedUp(
                                widget.ambulanceOrder.orderID);
                          }),
                    ]),
              ),
            ),
          ),
        ),
        // Patient Picked Up Sheet
        Visibility(
          visible: (widget.ambulanceOrder.status!.statusID == 2),
          child: Positioned(
            left: 10,
            right: 10,
            bottom: 10,
            child: Container(
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      const Text(
                        "Towards Hospital",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontFamily: 'Brand-Bold', fontSize: 22),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Divider(),
                      const SizedBox(
                        height: 10,
                      ),
                      RectangularButton(
                          title: "Destination Reached",
                          fontColor: Colors.white,
                          backgroundColor: Colors.blueAccent,
                          onPressed: () {
                            ServiceAssistant.destinationReached(
                                widget.ambulanceOrder.orderID,
                                widget.ambulanceOrder.dropOff!);
                            // Navigator.pop(context);
                          })
                    ]),
              ),
            ),
          ),
        )
      ]),
    );
  }
}
