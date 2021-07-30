import 'package:flutter/material.dart';
import 'home_page.dart';
import 'predictions_page.dart';
import 'standings_page.dart';

class MainScreen extends StatefulWidget {
  static const String id = 'main_screen';
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;
  final List<Widget> mainScreenChildren = [
    HomePage(),
    PredictionsPage(),
    StandingsPage()
  ];

  void onItemTapped(int index) {
    print(index);
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EURO PREDICTION'),
        backgroundColor: Colors.blue[900],
      ),
      backgroundColor: Colors.lightBlueAccent,
      body: mainScreenChildren[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Predictions'),
          BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard), label: 'Standings'),
        ],
        iconSize: 50.0,
        selectedItemColor: Colors.blueGrey[500],
        showUnselectedLabels: true,
        currentIndex: selectedIndex,
        onTap: onItemTapped,
      ),
    );
  }
}
