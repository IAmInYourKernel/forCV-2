import 'package:flutter/material.dart';
import 'package:healthka_customers/widgets/allButtons.dart';

class ConfirmSheet extends StatelessWidget {
  final String heading, message, cancelButtonMessage, chooseButtonMessage;
  final Function cancelButtonFunction, chooseButtonFunction;
  final Color chooseButtonColor;

  const ConfirmSheet(
      {Key? key,
      required this.heading,
      required this.message,
      required this.cancelButtonMessage,
      required this.chooseButtonMessage,
      required this.cancelButtonFunction,
      required this.chooseButtonFunction,
      required this.chooseButtonColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            heading,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 22, fontFamily: 'Brand-Bold', color: Colors.black87),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black54),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: OvalButton(
                    title: cancelButtonMessage,
                    fontColor: Colors.black87,
                    backgroundColor: Colors.white,
                    onPressed: () {
                      cancelButtonFunction();
                    }),
              ),
              const SizedBox(
                width: 30,
              ),
              Expanded(
                child: OvalButton(
                    title: chooseButtonMessage,
                    fontColor: Colors.white,
                    backgroundColor: chooseButtonColor,
                    onPressed: () {
                      chooseButtonFunction();
                    }),
              )
            ],
          )
        ]),
      ),
    );
  }
}
