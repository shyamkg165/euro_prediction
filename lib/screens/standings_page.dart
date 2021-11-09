import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;

class TotalPoints {
  String playerID;
  int totalResultPoints;
  int totalMomPoints;
  int totalAttackerPoints;
  int totalDefenderPoints;
  int sumOfAllPoints;
  TotalPoints(
      {this.playerID,
      this.totalResultPoints,
      this.totalMomPoints,
      this.totalAttackerPoints,
      this.totalDefenderPoints,
      this.sumOfAllPoints});
}

List<TotalPoints> totalPointsList = [];

class StandingsPage extends StatefulWidget {
  @override
  _StandingsPageState createState() => _StandingsPageState();
}

class _StandingsPageState extends State<StandingsPage> {
  @override
  void initState() {
    calculateStandings();

    super.initState();
  }

  void calculateStandings() async {
    String playerID;
    int totalResultPoints;
    int totalMomPoints;
    int totalAttackerPoints;
    int totalDefenderPoints;

    totalPointsList.clear();
    final playerNames = await _firestore.collection('matchpoints').get();
    for (var player in playerNames.docs) {

      playerID = player.id;

      totalResultPoints = 0;
      totalMomPoints = 0;
      totalAttackerPoints = 0;
      totalDefenderPoints = 0;

      final matches = await _firestore
          .collection('matchpoints')
          .doc(player.id)
          .collection('Matches')
          .get();

      for (var match in matches.docs) {

        totalResultPoints += match.data()["resultpoints"];
        totalMomPoints += match.data()["mompoints"];
        totalAttackerPoints += match.data()["attackerpoints"];
        totalDefenderPoints += match.data()["defenderpoints"];

      }
      print(totalResultPoints);
      print(totalMomPoints);
      print(totalAttackerPoints);
      print(totalDefenderPoints);

      final totalPoints = TotalPoints(
          playerID: playerID,
          totalResultPoints: totalResultPoints,
          totalMomPoints: totalMomPoints,
          totalAttackerPoints: totalAttackerPoints,
          totalDefenderPoints: totalDefenderPoints,
          sumOfAllPoints: (totalResultPoints +
              totalMomPoints +
              totalAttackerPoints +
              totalDefenderPoints));

      totalPointsList.add(totalPoints);
    }

    setState(() {
      sortStandings();
    });
  }

  void sortStandings(){
    totalPointsList.sort((a,b) => b.sumOfAllPoints.compareTo(a.sumOfAllPoints));
    int rank =0;
    for (var playerTotalPoints in totalPointsList){

      rank++;

      _firestore
          .collection('standings')
          .doc(playerTotalPoints.playerID)
          .set({
        'sumOfAllPoints': playerTotalPoints.sumOfAllPoints,
        'rank': rank
      }, SetOptions(merge: true)).then((_) {
        print("Standings Success!");
      });

    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      //child: ListView(children: widget.predictions),
      child: Column(
        children: <Widget>[
          Container(
            child: Table(
              border: TableBorder.all(
                  color: Colors.black, style: BorderStyle.solid, width: 2),
              children: [
                TableRow(children: [
                  Column(
                    children: [
                      Text('Player', style: TextStyle(fontSize: 20.0))
                    ],
                  ),
                  Column(
                    children: [
                      Text('ResultPoints', style: TextStyle(fontSize: 20.0))
                    ],
                  ),
                  Column(
                    children: [
                      Text('MOM Points', style: TextStyle(fontSize: 20.0))
                    ],
                  ),
                  Column(
                    children: [
                      Text('Attacker points', style: TextStyle(fontSize: 20.0))
                    ],
                  ),
                  Column(
                    children: [
                      Text('Defender points', style: TextStyle(fontSize: 20.0))
                    ],
                  ),
                  Column(
                    children: [
                      Text('Total Points', style: TextStyle(fontSize: 20.0))
                    ],
                  ),
                ]),
                for (var playerTotalPoints in totalPointsList)
                  TableRow(
                    children: [
                      Column(
                        children: [
                          Text(playerTotalPoints.playerID,
                              style: TextStyle(fontSize: 20.0))
                        ],
                      ),
                      Column(
                        children: [
                          Text(playerTotalPoints.totalResultPoints.toString(),
                              style: TextStyle(fontSize: 20.0))
                        ],
                      ),
                      Column(
                        children: [
                          Text(playerTotalPoints.totalMomPoints.toString(),
                              style: TextStyle(fontSize: 20.0))
                        ],
                      ),
                      Column(
                        children: [
                          Text(playerTotalPoints.totalAttackerPoints.toString(),
                              style: TextStyle(fontSize: 20.0))
                        ],
                      ),
                      Column(
                        children: [
                          Text(playerTotalPoints.totalDefenderPoints.toString(),
                              style: TextStyle(fontSize: 20.0))
                        ],
                      ),
                      Column(
                        children: [
                          Text(playerTotalPoints.sumOfAllPoints.toString(),
                              style: TextStyle(fontSize: 20.0))
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
