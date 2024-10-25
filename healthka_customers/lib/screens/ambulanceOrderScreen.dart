import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:healthka_customers/assistants/serviceAssistant.dart';
import 'package:healthka_customers/datahandler/serverData.dart';
import 'package:healthka_customers/models/ambulanceOrder.dart';
import 'package:healthka_customers/models/ambulanceOrderStatus.dart';
import 'package:healthka_customers/models/fare.dart';
import 'package:healthka_customers/models/location.dart';
import 'package:healthka_customers/widgets/allButtons.dart';

// ignore: must_be_immutable
class AmbulanceOrderScreen extends StatefulWidget {
  AmbulanceOrder ambulanceOrder;
  AmbulanceOrderScreen({super.key, required this.ambulanceOrder});

  @override
  State<AmbulanceOrderScreen> createState() => _AmbulanceOrderScreenState();
}

class _AmbulanceOrderScreenState extends State<AmbulanceOrderScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  late GoogleMapController _newController;

  Set<Marker> markersSet = {};
  Set<Polyline> polylineSet = {};

  late String distanceText;
  late String durationText;

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
    if (widget.ambulanceOrder.orderStatus!.statusID == 0) {
      setState(() {
        markersSet.add(pickUpLocMarker);
        markersSet.add(dropOffLocMarker);
      });
    } else if (widget.ambulanceOrder.orderStatus!.statusID == 1) {
      setState(() {
        markersSet.add(currentLocMarker);
        markersSet.add(pickUpLocMarker);
      });
    } else if (widget.ambulanceOrder.orderStatus!.statusID == 2) {
      setState(() {
        markersSet.add(currentLocMarker);
        markersSet.add(dropOffLocMarker);
      });
    }
  }

  // _setPolyLines() async {
  //   PolylinePoints polylinePoints = PolylinePoints();
  //   late DirectionDetails directionDetails;
  //   if (widget.ambulanceOrder.statusID == 1) {
  //     directionDetails = await ServiceAssistant.getDirectionDetails(
  //         widget.ambulanceOrder.currentLoc!, widget.ambulanceOrder.pickUp!);
  //   } else if (widget.ambulanceOrder.statusID == 2) {
  //     directionDetails = await ServiceAssistant.getDirectionDetails(
  //         widget.ambulanceOrder.currentLoc!, widget.ambulanceOrder.dropOff!);
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
  //     durationText = directionDetails.durationText;
  //     distanceText = directionDetails.distanceText;
  //   });
  // }

  _animateCameraToNavigation() {
    LatLngBounds latLngBounds;
    late LatLng pickUpLatLng;
    late LatLng dropOffLatLng;
    if (widget.ambulanceOrder.orderStatus!.statusID == 1) {
      pickUpLatLng = LatLng(
          widget.ambulanceOrder.pickUp!.lat, widget.ambulanceOrder.pickUp!.lng);
      dropOffLatLng = LatLng(widget.ambulanceOrder.currentLoc!.lat,
          widget.ambulanceOrder.currentLoc!.lng);
    } else if (widget.ambulanceOrder.orderStatus!.statusID == 2) {
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
    _newController
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 25));
  }

  _handleOngoingRide() async {
    ServiceAssistant.connectToOrderChannel();
    await ServiceAssistant.getOrderUpdatesCustomer(
        widget.ambulanceOrder.orderID);
    ongoingRideChannel!.stream.listen((response) {
      print(response);
      response = jsonDecode(response);
      if (response['resSuccess'] == 1) {
        var data = response['data'];
        var event = response['event'];
        if (event == "getOrderUpdatesCustomer") {
          setState(() {
            widget.ambulanceOrder.orderStatus =
                AmbulanceOrderStatus.fromJson(data['orderStatus']);
            widget.ambulanceOrder.currentLoc =
                Location.fromJson(data['loc']['currentLoc']);
          });
          if (widget.ambulanceOrder.orderStatus!.statusID == 1 ||
              widget.ambulanceOrder.orderStatus!.statusID == 2) {
            _setMarkers();
            _animateCameraToNavigation();
          }
          if (widget.ambulanceOrder.orderStatus!.statusID == 3) {
            widget.ambulanceOrder.actualFare =
                Fare.fromJson(data['actualFare']);
          }
          if (widget.ambulanceOrder.orderStatus!.statusID == 4) {
            Navigator.pop(context);
          }
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _handleOngoingRide();
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
        Visibility(
          visible: (widget.ambulanceOrder.orderStatus!.statusID == 1 ||
              widget.ambulanceOrder.orderStatus!.statusID == 2),
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

        Visibility(
          visible: (widget.ambulanceOrder.orderStatus!.statusID == 3),
          child: Scaffold(
            body: Center(
              child: Column(
                children: [
                  Text("Please Pay By Cash to Driver"),
                  Text((widget.ambulanceOrder.actualFare!.value).toString()),
                ],
              ),
            ),
          ),
        ),

        // Ride Confirmed Sheet
        Visibility(
          visible: (widget.ambulanceOrder.orderStatus!.statusID == 1),
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
                        "Ambulance is On the Way",
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
                      Text(
                        "Ambulance Type: ${widget.ambulanceOrder.ambulance!.type!.name}",
                        style: const TextStyle(
                            fontFamily: 'Brand-Regular', fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Driver Name: ${widget.ambulanceOrder.driver!.driverID}",
                        style: const TextStyle(
                            fontFamily: 'Brand-Regular', fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Car Number: ${widget.ambulanceOrder.ambulance!.carID}",
                        style: const TextStyle(
                            fontFamily: 'Brand-Regular', fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RectangularButton(
                          title: "Call Driver",
                          fontColor: Colors.white,
                          backgroundColor: Colors.blueAccent,
                          onPressed: () {})
                    ]),
              ),
            ),
          ),
        ),

        // Patient Picked Up Sheet
        Visibility(
          visible: (widget.ambulanceOrder.orderStatus!.statusID == 2),
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
                      Text(
                        "Ambulance Type: ${widget.ambulanceOrder.ambulance!.type!.name}",
                        style: const TextStyle(
                            fontFamily: 'Brand-Regular', fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Driver Name: ${widget.ambulanceOrder.driver!.driverID}",
                        style: const TextStyle(
                            fontFamily: 'Brand-Regular', fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Car Number: ${widget.ambulanceOrder.ambulance!.carID}",
                        style: const TextStyle(
                            fontFamily: 'Brand-Regular', fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RectangularButton(
                          title: "Call Driver",
                          fontColor: Colors.white,
                          backgroundColor: Colors.blueAccent,
                          onPressed: () {})
                    ]),
              ),
            ),
          ),
        )
      ]),
    );
  }
}
