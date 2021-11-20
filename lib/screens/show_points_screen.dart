import 'package:flutter/material.dart';
import 'package:Euro_prediction/functions/calculate_write_points.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Euro_prediction/constants.dart';
import 'package:Euro_prediction/display/scrollable_widget.dart';

final _firestore = FirebaseFirestore.instance;
int matchNum;
String playerId;
String matchResult;
String manOfMatch;
String bestAttacker;
String bestDefender;
List<PlayerMatchPoints> playerMatchPointsList = [];

class ShowPointsScreen extends StatefulWidget {
  ShowPointsScreen({@required this.matchNum});

  static const String id = 'show_points_screen';
  final int matchNum;

  @override
  _ShowPointsScreenState createState() => _ShowPointsScreenState();
}

class _ShowPointsScreenState extends State<ShowPointsScreen> {
  int sortColumnIndex;
  bool isAscending = false;
  @override
  void initState() {
    // TODO: implement initState

    getPlayerMatchPoints(widget.matchNum);
    super.initState();
  }

  void getPlayerMatchPoints(int matchNumber) async {
    int playerResultPoints = 0;
    int playerMomPoints = 0;
    int playerAttackerPoints = 0;
    int playerDefenderPoints = 0;
    int playerTotalPoints = 0;

    print('in getPlayerMatchPoints');

    final playerNames = await _firestore.collection('matchpoints').get();

    playerMatchPointsList.clear();
    for (var player in playerNames.docs) {
      playerId = player.id;

      final currentMatch = await _firestore
          .collection('matchpoints')
          .doc(player.id)
          .collection('Matches')
          .where("matchnum", isEqualTo: matchNumber)
          .get();

      if (!currentMatch.docs.isEmpty) {
        for (var match in currentMatch.docs) {
          matchNum = match.data()['matchnum'];
          playerResultPoints = match.data()['resultpoints'];
          playerMomPoints = match.data()['mompoints'];
          playerAttackerPoints = match.data()['attackerpoints'];
          playerDefenderPoints = match.data()['defenderpoints'];
          playerTotalPoints = playerResultPoints +
              playerMomPoints +
              playerAttackerPoints +
              playerDefenderPoints;
        }
      } else {
        matchNum = matchNumber;
      }

      print(playerId);
      print(matchNum);
      print(playerResultPoints);
      print(playerMomPoints);
      print(playerAttackerPoints);
      print(playerDefenderPoints);

      final playerMatchPoints = PlayerMatchPoints(
          playerID: playerId,
          playerResultPoints: playerResultPoints,
          playerMomPoints: playerMomPoints,
          playerAttackerPoints: playerAttackerPoints,
          playerDefenderPoints: playerDefenderPoints,
          playerTotalPoints: playerTotalPoints);

      playerMatchPointsList.add(playerMatchPoints);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(logoPath),
            fit: BoxFit.contain,
          ),
        ),
        child: ScrollableWidget(child: buildDataTable()),
      ),
    );
  }

  Widget buildDataTable() {
    final columns = [
      'Player',
      'Match Num',
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
      rows: getRows(playerMatchPointsList),
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            label: Text(column),
            onSort: onSort,
          ))
      .toList();

  List<DataRow> getRows(List<PlayerMatchPoints> matchPointsList) =>
      playerMatchPointsList.map((PlayerMatchPoints playerMatchPoints) {
        final cells = [
          playerMatchPoints.playerID,
          matchNum,
          playerMatchPoints.playerResultPoints,
          playerMatchPoints.playerMomPoints,
          playerMatchPoints.playerAttackerPoints,
          playerMatchPoints.playerDefenderPoints,
          playerMatchPoints.playerTotalPoints
        ];

        return DataRow(cells: getCells(cells));
      }).toList();

  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(Text('$data'))).toList();

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      playerMatchPointsList.sort((user1, user2) => compareInt(
          ascending, user1.playerTotalPoints, user2.playerTotalPoints));
    } else if (columnIndex == 1) {
      playerMatchPointsList.sort((user1, user2) => compareInt(
          ascending, user1.playerResultPoints, user2.playerResultPoints));
    } else if (columnIndex == 2) {
      playerMatchPointsList.sort((user1, user2) =>
          compareInt(ascending, user1.playerMomPoints, user2.playerMomPoints));
    } else if (columnIndex == 3) {
      playerMatchPointsList.sort((user1, user2) => compareInt(
          ascending, user1.playerAttackerPoints, user2.playerAttackerPoints));
    } else if (columnIndex == 4) {
      playerMatchPointsList.sort((user1, user2) => compareInt(
          ascending, user1.playerDefenderPoints, user2.playerDefenderPoints));
    } else if (columnIndex == 5) {
      playerMatchPointsList.sort((user1, user2) => compareInt(
          ascending, user1.playerTotalPoints, user2.playerTotalPoints));
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
    return Scaffold(
      appBar: AppBar(
        title: Text('EURO PREDICTION'),
        backgroundColor: Colors.blue[900],
      ),
      backgroundColor: Colors.lightBlueAccent,
      body: Container(
        //child: ListView(children: widget.predictions),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(logoPath),
            fit: BoxFit.cover,
          ),
        ),
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
                        Text('MatchNum', style: TextStyle(fontSize: 20.0))
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
                        Text('Attacker points',
                            style: TextStyle(fontSize: 20.0))
                      ],
                    ),
                    Column(
                      children: [
                        Text('Defender points',
                            style: TextStyle(fontSize: 20.0))
                      ],
                    ),
                  ]),
                  for (var playerMatchPoints in playerMatchPointsList)
                    TableRow(
                      children: [
                        Column(
                          children: [
                            Text(playerMatchPoints.playerID,
                                style: TextStyle(fontSize: 20.0))
                          ],
                        ),
                        Column(
                          children: [
                            Text(widget.matchNum.toString(),
                                style: TextStyle(fontSize: 20.0))
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                                playerMatchPoints.playerResultPoints.toString(),
                                style: TextStyle(fontSize: 20.0))
                          ],
                        ),
                        Column(
                          children: [
                            Text(playerMatchPoints.playerMomPoints.toString(),
                                style: TextStyle(fontSize: 20.0))
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                                playerMatchPoints.playerAttackerPoints
                                    .toString(),
                                style: TextStyle(fontSize: 20.0))
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                                playerMatchPoints.playerDefenderPoints
                                    .toString(),
                                style: TextStyle(fontSize: 20.0))
                          ],
                        ),
                      ],
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }*/
}
