import 'package:flutter/material.dart';
import 'package:healthka_customers/models/ambulance.dart';
import 'package:healthka_customers/widgets/allButtons.dart';
import 'package:healthka_customers/widgets/ambulanceFeatureTile.dart';

class AmbulanceTypeDeatilsScreen extends StatefulWidget {
  final Ambulance ambulance;
  const AmbulanceTypeDeatilsScreen({super.key, required this.ambulance});

  @override
  State<AmbulanceTypeDeatilsScreen> createState() =>
      _AmbulanceTypeDeatilsScreenState();
}

class _AmbulanceTypeDeatilsScreenState
    extends State<AmbulanceTypeDeatilsScreen> {
  _handleFareChange(feature, featureIndex) {
    if (feature.featureSelected == true) {
      setState(() {
        widget.ambulance.features![featureIndex] = feature;
        widget.ambulance.fareEstimate!.value =
            widget.ambulance.fareEstimate!.value! + feature.featureCost.value;
      });
    } else {
      setState(() {
        widget.ambulance.fareEstimate!.value =
            widget.ambulance.fareEstimate!.value! - feature.featureCost.value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Back button in app bar
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context, null);
          },
          child: const Icon(
            Icons.arrow_back_sharp,
            size: 30,
            color: Colors.white,
          ),
        ),
        title: const Text(
          "Confirm Your Ambulance",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromARGB(191, 2, 2, 2),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(
            height: 10,
          ),
          Text(widget.ambulance.type!.name!,
              style: const TextStyle(fontFamily: "Brand-Bold", fontSize: 20)),
          Image.asset(
            "assets/images/car_android.png",
            height: 60,
            width: 60,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
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
            child: Column(
              children: [
                const Text(
                  "Add Extra Features",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Brand-Regular"),
                ),
                ListView.builder(
                  padding: const EdgeInsets.all(0),
                  itemBuilder: (context, featureIndex) {
                    return Column(
                      children: [
                        AmbulanceFeatureTile(
                          feature: widget.ambulance.features![featureIndex],
                          onChanged: (feature) =>
                              _handleFareChange(feature, featureIndex),
                        ),
                        Divider()
                      ],
                    );
                  },
                  itemCount: widget.ambulance.features!.length,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                ),
              ],
            ),
          ),
          Text(
            "Fare Estimate = ${widget.ambulance.fareEstimate!.currency} ${widget.ambulance.fareEstimate!.value}",
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontFamily: "Brand-Regular"),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: OvalButton(
                title: "CONFIRM AMBULANCE",
                fontColor: Colors.white,
                backgroundColor: Colors.redAccent,
                onPressed: () {
                  Navigator.pop(context, widget.ambulance);
                }),
          )
        ]),
      ),
    );
  }
}
