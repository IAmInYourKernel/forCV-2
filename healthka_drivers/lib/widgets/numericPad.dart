import 'package:flutter/material.dart';

class NumericPad extends StatelessWidget {
  final Function(int) onNumberSelected;

  NumericPad({required this.onNumberSelected});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      color: const Color(0xFFF5F4F9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            height: height * 0.075,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildNumber(1),
                buildNumber(2),
                buildNumber(3),
              ],
            ),
          ),
          Container(
            height: height * 0.075,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildNumber(4),
                buildNumber(5),
                buildNumber(6),
              ],
            ),
          ),
          Container(
            height: height * 0.075,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildNumber(7),
                buildNumber(8),
                buildNumber(9),
              ],
            ),
          ),
          Container(
            height: height * 0.075,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildEmptySpace(),
                buildNumber(0),
                buildBackspace(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNumber(int number) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(5),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black26,
                blurRadius: 2.0,
                spreadRadius: 0.5,
                offset: Offset(0.0, 0.75))
          ],
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: TextButton(
          onPressed: () {
            onNumberSelected(number);
          },
          child: Center(
            child: Text(
              number.toString(),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F1F1F),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBackspace() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(5),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black26,
                blurRadius: 2.0,
                spreadRadius: 0.5,
                offset: Offset(0.0, 0.75))
          ],
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: TextButton(
          onPressed: () {
            onNumberSelected(-1);
          },
          child: const Center(
            child: Icon(
              Icons.backspace,
              size: 28,
              color: Color(0xFF1F1F1F),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildEmptySpace() {
    return Expanded(
      child: Container(),
    );
  }
}
