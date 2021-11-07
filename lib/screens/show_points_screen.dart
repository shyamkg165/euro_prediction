import 'package:flutter/material.dart';
import 'package:Euro_prediction/functions/calculate_write_points.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  @override
  void initState() {
    // TODO: implement initState

    getPlayerMatchPoints(widget.matchNum);
    super.initState();
  }

  void getPlayerMatchPoints(int matchNumber) async {
    int playerResultPoints;
    int playerMomPoints;
    int playerAttackerPoints;
    int playerDefenderPoints;

    print ('in getPlayerMatchPoints');

    final playerNames = await _firestore
        .collection('matchpoints')
        .get();

    playerMatchPointsList.clear();
    for (var player in playerNames.docs) {

      playerId = player.id;

      final currentMatch = await _firestore
          .collection('matchpoints')
          .doc(player.id)
          .collection('Matches')
          .where("matchnum", isEqualTo: matchNumber)
          .get();

      for (var match in currentMatch.docs){
        matchNum = match.data()['matchnum'];
        playerResultPoints = match.data()['resultpoints'];
        playerMomPoints = match.data()['mompoints'];
        playerAttackerPoints = match.data()['attackerpoints'];
        playerDefenderPoints = match.data()['defenderpoints'];
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
          playerDefenderPoints: playerDefenderPoints);

      playerMatchPointsList.add(playerMatchPoints);
    }
    setState(() {

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
      body: Container(
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
                                  playerMatchPoints.playerResultPoints
                                      .toString(),
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
  }
}

