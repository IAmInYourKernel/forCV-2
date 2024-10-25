import 'package:flutter/material.dart';

class LocationButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LocationButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 240),
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        child: const Icon(Icons.gps_fixed_rounded),
      ),
    );
  }
}
