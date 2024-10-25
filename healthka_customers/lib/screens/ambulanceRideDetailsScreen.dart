import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:healthka_customers/assistants/serviceAssistant.dart';
import 'package:healthka_customers/models/location.dart';
import 'package:healthka_customers/models/rideDetails.dart';
import 'package:healthka_customers/screens/ambulanceTypeDetailsScreen.dart';
import 'package:healthka_customers/widgets/ambulanceTile.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AmbulanceRideDeatilsScreen extends StatefulWidget {
  final Location pickUp;
  final Location dropOff;
  const AmbulanceRideDeatilsScreen(
      {super.key, required this.pickUp, required this.dropOff});

  @override
  State<AmbulanceRideDeatilsScreen> createState() =>
      _AmbulanceRideDeatilsScreenState();
}

class _AmbulanceRideDeatilsScreenState
    extends State<AmbulanceRideDeatilsScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  late GoogleMapController _newController;

  Set<Marker> markersSet = {};
  Set<Polyline> polylineSet = {};

  RideDetails? rideDetails;

  @override
  void dispose() {
    debugPrint("DISPOSE CALLED FOR RIDE DETAILS SCREEN");
    _controller.future.then((value) => value.dispose());
    _newController.dispose();
    super.dispose();
  }

  _setMarkers() {
    Marker pickUpLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      markerId: const MarkerId("pickUpMarker"),
      position: LatLng(widget.pickUp.lat, widget.pickUp.lng),
    );
    Marker dropOffLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      markerId: const MarkerId("dropOffMarker"),
      position: LatLng(widget.dropOff.lat, widget.dropOff.lng),
    );
    setState(() {
      markersSet.add(pickUpLocMarker);
      markersSet.add(dropOffLocMarker);
    });
  }

  _animateCameraToNavigation() {
    LatLngBounds latLngBounds;
    LatLng pickUpLatLng = LatLng(widget.pickUp.lat, widget.pickUp.lng);
    LatLng dropOffLatLng = LatLng(widget.dropOff.lat, widget.dropOff.lng);
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

  _getRideDetails() async {
    var response = await ServiceAssistant.getInitialFareEstimate(
        widget.pickUp, widget.dropOff);
    setState(() {
      rideDetails = response;
    });
  }

  _setPolyLines() {
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResult = polylinePoints
        .decodePolyline(rideDetails!.directionDetails.encodedPoints);

    List<LatLng> pLineCoordinates = [];
    if (decodedPolyLinePointsResult.isNotEmpty) {
      for (PointLatLng pointLatLng in decodedPolyLinePointsResult) {
        pLineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      }
    }
    setState(() {
      Polyline polyline = Polyline(
        color: const Color.fromARGB(255, 233, 80, 10),
        polylineId: const PolylineId("PolylineID"),
        jointType: JointType.round,
        points: pLineCoordinates,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );
      polylineSet.add(polyline);
    });
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
          "Choose Your Ambulance",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(191, 2, 2, 2),
        elevation: 0,
        centerTitle: true,
      ),
      body: SlidingUpPanel(
        backdropEnabled: true,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
        minHeight: 200,
        panel: AnimatedSize(
            duration: const Duration(milliseconds: 150),
            curve: Curves.bounceIn,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 15.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    )
                  ]),
              child: rideDetails != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(0),
                        itemBuilder: (context, index) {
                          return TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          AmbulanceTypeDeatilsScreen(
                                            ambulance: rideDetails!
                                                .ambulanceList[index],
                                          ))).then((value) {
                                Navigator.pop(context, value);
                              });
                            },
                            child: AmbulanceTile(
                              ambulance:
                                  rideDetails!.ambulanceList.elementAt(index),
                            ),
                          );
                        },
                        itemCount: rideDetails!.ambulanceList.length,
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                      ),
                    )
                  : Container(),
            )),
        body: GoogleMap(
            mapType: MapType.normal,
            padding: EdgeInsets.only(bottom: 250),
            initialCameraPosition: CameraPosition(
                target: LatLng(widget.pickUp.lat, widget.pickUp.lng), zoom: 18),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              _newController = controller;
              SchedulerBinding.instance.addPostFrameCallback((_) async {
                _setMarkers();
                await _getRideDetails();
                _animateCameraToNavigation();
                _setPolyLines();
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
    );
  }
}
