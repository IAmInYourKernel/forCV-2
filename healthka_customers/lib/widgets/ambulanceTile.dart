import 'package:flutter/material.dart';
import 'package:healthka_customers/models/ambulance.dart';

// ignore: must_be_immutable
class AmbulanceTile extends StatelessWidget {
  final Ambulance ambulance;

  AmbulanceTile({Key? key, required this.ambulance}) : super(key: key);

  final String ambulancePic = "assets/images/car_android.png";

  // late String ambulanceName = ambulance.typeName;

  late String? ambulanceType = ambulance.type!.name;

  late String? ambulanceFareCurrency = ambulance.fareEstimate!.currency;

  late num? ambulanceFareValue = ambulance.fareEstimate!.value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(children: [
        Image.asset(
          ambulancePic,
          height: 60,
          width: 60,
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 8,
              ),
              Text(
                ambulanceType.toString(),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontFamily: "Brand-Bold",
                    fontSize: 15,
                    color: Color.fromARGB(255, 46, 38, 38)),
              ),
              // const SizedBox(
              //   height: 8,
              // ),
              // Text(
              //   ambulanceType,
              //   overflow: TextOverflow.ellipsis,
              //   style: const TextStyle(fontSize: 15, color: Colors.grey),
              // ),
              // const SizedBox(
              //   height: 8,
              // ),
            ],
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          "$ambulanceFareCurrency $ambulanceFareValue",
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              fontSize: 15, color: Color.fromARGB(255, 46, 38, 38)),
        ),
      ]),
    );
  }
}
