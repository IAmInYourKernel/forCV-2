import 'package:flutter/material.dart';

class OvalButton extends StatelessWidget {
  final String title;
  final Color fontColor;
  final Color backgroundColor;
  final VoidCallback onPressed;

  const OvalButton(
      {Key? key,
      required this.title,
      required this.fontColor,
      required this.backgroundColor,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
          foregroundColor: fontColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          backgroundColor: backgroundColor),
      child: SizedBox(
        height: 50,
        child: Center(
            child: Text(
          title,
          style: const TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),
        )),
      ),
    );
  }
}

class RectangularButton extends StatelessWidget {
  final String title;
  final Color fontColor;
  final Color backgroundColor;
  final VoidCallback onPressed;

  const RectangularButton(
      {Key? key,
      required this.title,
      required this.fontColor,
      required this.backgroundColor,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
          foregroundColor: fontColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          backgroundColor: backgroundColor),
      child: SizedBox(
        height: 50,
        child: Center(
            child: Text(
          title,
          style: const TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),
        )),
      ),
    );
  }
}
