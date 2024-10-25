import 'package:flutter/material.dart';
import 'package:healthka_customers/screens/homeScreen.dart';
import 'package:healthka_customers/screens/patientScreen.dart';
import 'package:healthka_customers/screens/profileScreen.dart';
import 'package:healthka_customers/transferToMain/widgetFolder/medicineUi-1.dart';

class MainScreen extends StatefulWidget {
  static const String idScreen = "mainScreen";
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // 0 - Home, 1 - Family, 2 - Orders, 3 - Profile
  int _bottomBarIndex = 0;

  // Changes the bottom bar index
  _changeBottomBarIndex(int index) {
    setState(() {
      _bottomBarIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: _bottomBarIndex == 0
              ? HomeScreen()
              : _bottomBarIndex == 1
                  ? PatientScreen()
                  : _bottomBarIndex == 2
                      ? MedicineUi()
                      : ProfileScreen()),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomBarIndex,
        onTap: _changeBottomBarIndex,
        backgroundColor: Color.fromARGB(191, 2, 2, 2),
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.greenAccent,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.family_restroom),
            label: 'Family',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Orders',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
