import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CircularProgress extends StatelessWidget {
  String status = "Loading..";

  CircularProgress({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("BUILDINGGGG DIALOGGGG");
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            const SizedBox(
              width: 2,
            ),
            const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent)),
            const SizedBox(
              width: 30,
            ),
            Text(
              status,
              style: const TextStyle(fontSize: 15),
            ),
          ]),
        ),
      ),
    );
  }
}
