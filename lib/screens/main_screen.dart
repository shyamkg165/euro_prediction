import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'predictions_page.dart';
import 'standings_page.dart';
import 'completed_match_page.dart';

class MainScreen extends StatefulWidget {
  static const String id = 'main_screen';
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _auth = FirebaseAuth.instance;
  final messageTextController = TextEditingController();

  String messageText;

  User loggedInUser;

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() {
    final user = _auth.currentUser;
    if (user != null) {
      loggedInUser = user;
      print(loggedInUser.email);
    }
    if (loggedInUser.email == "shyam@gmail.com") {
      mainScreenChildren = [
        HomePage(),
        PredictionsPage(),
        StandingsPage(),
        CompletedMatchPage(),
      ];

      bottomNavigationList = [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star),
          label: 'Predictions',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.leaderboard),
          label: 'Standings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.smart_toy_rounded),
          label: 'Admin',
        ),
      ];
    } else {
      mainScreenChildren = [
        HomePage(),
        PredictionsPage(),
        StandingsPage(),
      ];

      bottomNavigationList = [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star),
          label: 'Predictions',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.leaderboard),
          label: 'Standings',
        ),
      ];
    }
  }

  int selectedIndex = 0;
  List<Widget> mainScreenChildren;

  void onItemTapped(int index) {
    print(index);
    setState(() {
      selectedIndex = index;
    });
  }

  List<BottomNavigationBarItem> bottomNavigationList;

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
        items: bottomNavigationList,
        iconSize: 40.0,
        selectedItemColor: Colors.blueGrey[500],
        unselectedItemColor: Colors.blueGrey[500],
        currentIndex: selectedIndex,
        onTap: onItemTapped,
      ),
    );
  }
}
