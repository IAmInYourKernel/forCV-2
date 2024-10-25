import 'package:flutter/material.dart';
import 'package:healthka_drivers/screens/bookingsScreen.dart';
import 'package:healthka_drivers/screens/homeScreen.dart';
import 'package:healthka_drivers/screens/paymentsScreen.dart';
import 'package:healthka_drivers/screens/profileScreen.dart';

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
                  ? BookingsScreen()
                  : _bottomBarIndex == 2
                      ? PaymentsScreen()
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
            icon: Icon(Icons.taxi_alert),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Payments',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
