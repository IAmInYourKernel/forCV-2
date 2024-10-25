import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:healthka_drivers/assistants/serviceAssistant.dart';
import 'package:healthka_drivers/datahandler/appData.dart';
import 'package:healthka_drivers/models/ambulanceOrder.dart';
import 'package:healthka_drivers/screens/finishedOrderScreen.dart';
import 'package:healthka_drivers/screens/rideScreen.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  List<dynamic> bookingsList = [];
  bool isLoading = true;

  void _getBookings() async {
    var tempList = await ServiceAssistant.getBookings();
    setState(() {
      bookingsList = tempList;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookings'),
      ),
      body: Container(
        child: isLoading
            ? const CircularProgressIndicator() // Show loading indicator while waiting for API response
            : bookingsList.isEmpty
                ? const Text('No Bookings')
                : ListView.builder(
                    itemCount: bookingsList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
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
                        child: TextButton(
                          onPressed: () async {
                            AmbulanceOrder ambulanceOrder =
                                await ServiceAssistant.getBookingByID(
                                    bookingsList[index]['orderID']);
                            if (ambulanceOrder.status!.statusID == 4 ||
                                ambulanceOrder.status!.statusID == 5) {
                              navigatorKey.currentState!.push(MaterialPageRoute(
                                  builder: (context) =>
                                      FinishedOrderScreen(ambulanceOrder)));
                            } else {
                              navigatorKey.currentState!.push(MaterialPageRoute(
                                  builder: (context) =>
                                      RideScreen(ambulanceOrder)));
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 18),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(bookingsList[index]['orderID']),
                                  Text(bookingsList[index]['orderStatus']
                                          ['status']
                                      .toString()),
                                ]),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
