import 'package:flutter/material.dart';
import 'package:healthka_customers/models/ambulanceFeature.dart';
import 'package:healthka_customers/widgets/toastMessage.dart';

class AmbulanceFeatureTile extends StatefulWidget {
  final AmbulanceFeature feature;
  final Function(AmbulanceFeature) onChanged;
  const AmbulanceFeatureTile(
      {super.key, required this.feature, required this.onChanged});

  @override
  State<AmbulanceFeatureTile> createState() => _AmbulanceFeatureTileState();
}

class _AmbulanceFeatureTileState extends State<AmbulanceFeatureTile> {
  void _updateSelected(bool value) {
    if (widget.feature.featureCost!.value == 0) {
      displayToastMessage("Cannot be selected", context);
    } else {
      // Update the value of the object
      setState(() {
        widget.feature.featureSelected = value;
      });

      // Invoke the callback function in the parent widget
      widget.onChanged(widget.feature);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(children: [
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 8,
              ),
              Text(
                widget.feature.featureName!,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 15, color: Color.fromARGB(255, 46, 38, 38)),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                "${widget.feature.featureCost!.currency} ${widget.feature.featureCost!.value}",
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 15, color: Colors.grey),
              ),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Switch(
          activeColor: Colors.green,
          activeTrackColor: Colors.greenAccent,
          inactiveThumbColor: Colors.red,
          inactiveTrackColor: Color.fromARGB(255, 219, 124, 124),
          onChanged: (bool value) => _updateSelected(value),
          value: widget.feature.featureSelected!,
        )
      ]),
    );
  }
}
