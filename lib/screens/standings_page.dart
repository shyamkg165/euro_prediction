import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Euro_prediction/display/scrollable_widget.dart';

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

  int sortColumnIndex;
  bool isAscending = false;

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
    return Scaffold(
      body: ScrollableWidget(child: buildDataTable()),
    );
  }

  Widget buildDataTable() {
    final columns = [
      'Player',
      'Result Points',
      'MOM Points',
      'Attacker points',
      'Defender points',
      'Total Points'
    ];

    return DataTable(
      sortAscending: isAscending,
      sortColumnIndex: sortColumnIndex,
      columns: getColumns(columns),
      rows: getRows(totalPointsList),
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
    label: Text(column),
    onSort: onSort,
  ))
      .toList();

  List<DataRow> getRows(List<TotalPoints> totalPointsList) =>
      totalPointsList.map((TotalPoints playerTotalPoints) {
        final cells = [
          playerTotalPoints.playerID,
          playerTotalPoints.totalResultPoints,
          playerTotalPoints.totalMomPoints,
          playerTotalPoints.totalAttackerPoints,
          playerTotalPoints.totalDefenderPoints,
          playerTotalPoints.sumOfAllPoints
        ];

        return DataRow(cells: getCells(cells));
      }).toList();

  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(Text('$data'))).toList();

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      totalPointsList.sort((user1, user2) =>
          compareInt(ascending, user1.sumOfAllPoints, user2.sumOfAllPoints));
    } else if (columnIndex == 1) {
      totalPointsList.sort((user1, user2) => compareInt(
          ascending, user1.totalResultPoints, user2.totalResultPoints));
    } else if (columnIndex == 2) {
      totalPointsList.sort((user1, user2) =>
          compareInt(ascending, user1.totalMomPoints, user2.totalMomPoints));
    } else if (columnIndex == 3) {
      totalPointsList.sort((user1, user2) => compareInt(
          ascending, user1.totalAttackerPoints, user2.totalAttackerPoints));
    } else if (columnIndex == 4) {
      totalPointsList.sort((user1, user2) => compareInt(
          ascending, user1.totalDefenderPoints, user2.totalDefenderPoints));
    } else if (columnIndex == 5) {
      totalPointsList.sort((user1, user2) =>
          compareInt(ascending, user1.sumOfAllPoints, user2.sumOfAllPoints));
    }
    setState(() {
      this.sortColumnIndex = columnIndex;
      this.isAscending = ascending;
    });
  }

  int compareInt(bool ascending, int value1, int value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);

  /*@override
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
  }*/
}
