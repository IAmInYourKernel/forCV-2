import 'package:flutter/material.dart';
import 'package:healthka_customers/screens/ambulanceScreen.dart';
import 'package:healthka_customers/transferToMain/widgetFolder/medicineUi-1.dart';

import 'package:healthka_customers/widgets/allButtons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 0 - Medicine, 1 - Ambulance
  int _topBarIndex = 0;

  Color _ambulanceButtonColor = Colors.grey;
  Color _medicineButtonColor = Colors.green;

  // Changes the top bar index
  _changeTopBarIndex(int option) {
    setState(() {
      _topBarIndex = option;
      if (option == 1) {
        _ambulanceButtonColor = Colors.green;
        _medicineButtonColor = Colors.grey;
      } else {
        _ambulanceButtonColor = Colors.grey;
        _medicineButtonColor = Colors.green;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 15),
          color: Color.fromARGB(191, 2, 2, 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RectangularButton(
                  title: "Medicine",
                  fontColor: Colors.white,
                  backgroundColor: _medicineButtonColor,
                  onPressed: () => _changeTopBarIndex(0)),
              SizedBox(
                width: 30,
              ),
              RectangularButton(
                  title: "Ambulance",
                  fontColor: Colors.white,
                  backgroundColor: _ambulanceButtonColor,
                  onPressed: () => _changeTopBarIndex(1)),
            ],
          ),
        ),
        Expanded(
          child: _topBarIndex == 1 ? AmbulanceScreen() : MedicineUi(),
        ),
      ],
    );
  }
}
