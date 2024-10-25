import 'dart:async';
import 'package:capped_progress_indicator/capped_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:healthka_customers/assistants/serviceAssistant.dart';
import 'package:healthka_customers/models/ambulanceOrder.dart';

// ignore: must_be_immutable
class AmbulanceRequestScreen extends StatefulWidget {
  AmbulanceOrder ambulanceOrder;
  AmbulanceRequestScreen({super.key, required this.ambulanceOrder});

  @override
  State<AmbulanceRequestScreen> createState() => _AmbulanceRequestScreenState();
}

class _AmbulanceRequestScreenState extends State<AmbulanceRequestScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  late GoogleMapController _newController;

  Set<Marker> markersSet = {};
  Set<Polyline> polylineSet = {};

  late String distanceText;
  late String durationText;

  int cancelStatus = 0;

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
    markersSet.add(pickUpLocMarker);
    markersSet.add(dropOffLocMarker);
  }

  _animateCameraToNavigation() {
    LatLngBounds latLngBounds;
    late LatLng pickUpLatLng;
    late LatLng dropOffLatLng;
    pickUpLatLng = LatLng(
        widget.ambulanceOrder.pickUp!.lat, widget.ambulanceOrder.pickUp!.lng);
    dropOffLatLng = LatLng(
        widget.ambulanceOrder.dropOff!.lat, widget.ambulanceOrder.dropOff!.lng);

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

  _handleRideRequest() async {
    var res = await ServiceAssistant.createAmbulanceRequest(
        widget.ambulanceOrder, context);
    // ignore: use_build_context_synchronously
    Navigator.pop(context, res);
  }

  _handleCancelRideRequest(context) async {
    setState(() {
      cancelStatus = 1;
    });
    ServiceAssistant.cancelAmbulanceRequest();
  }

  @override
  void initState() {
    super.initState();
    _handleRideRequest();
  }

  @override
  void dispose() {
    debugPrint("DISPOSE CALLED FOR ORDER DETAILS SCREEN");
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
        GoogleMap(
            mapType: MapType.normal,
            padding: EdgeInsets.only(bottom: 250),
            initialCameraPosition: CameraPosition(
                target: LatLng(widget.ambulanceOrder.pickUp!.lat,
                    widget.ambulanceOrder.pickUp!.lng),
                zoom: 18),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              _newController = controller;
              SchedulerBinding.instance.addPostFrameCallback((_) async {
                _setMarkers();
              });
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

        // Ride Requesting Sheet
        Visibility(
          visible: (cancelStatus == 0),
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
                      const LinearCappedProgressIndicator(
                        value: null,
                        cornerRadius: 5,
                        minHeight: 10,
                        backgroundColor: Colors.white,
                        color: Colors.redAccent,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      const Text(
                        "Requesting an Amublance",
                        style: const TextStyle(
                            fontFamily: 'Brand-Bold', fontSize: 22),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          _handleCancelRideRequest(context);
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(width: 1),
                          ),
                          child: const Icon(Icons.close_rounded),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                              fontSize: 12, fontFamily: 'Brand-Regular'),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ]),
              ),
            ),
          ),
        ),

        // Ride Request Cancelling Sheet
        Visibility(
          visible: (cancelStatus == 1),
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
                      const CircularCappedProgressIndicator(
                        value: null,
                        backgroundColor: Colors.white,
                        color: Colors.redAccent,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      const Text(
                        "Cancelling the Request",
                        style: const TextStyle(
                            fontFamily: 'Brand-Bold', fontSize: 22),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        "It may take some seconds. Please Wait",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontFamily: 'Brand-Bold', fontSize: 22),
                      ),
                    ]),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
