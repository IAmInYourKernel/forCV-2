import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:healthka_drivers/models/ambulanceOrder.dart';

class FinishedOrderScreen extends StatelessWidget {
  AmbulanceOrder ambulanceOrder;
  FinishedOrderScreen(this.ambulanceOrder, {super.key});

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
      body: Center(child: Text('DONE')),
    );
  }
}
