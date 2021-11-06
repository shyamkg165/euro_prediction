import 'package:flutter/material.dart';
import 'package:Euro_prediction/functions/calculate_write_points.dart';

int matchNum;
String playerId;
String matchResult;
String manOfMatch;
String bestAttacker;
String bestDefender;

class ShowPointsScreen extends StatefulWidget {
  ShowPointsScreen({@required this.matchNum, @required this.playerMatchPoints});

  static const String id = 'show_points_screen';
  final int matchNum;
  final List<PlayerMatchPoints> playerMatchPoints;

  @override
  _ShowPointsScreenState createState() => _ShowPointsScreenState();
}

class _ShowPointsScreenState extends State<ShowPointsScreen> {
  @override
  void initState() {
    // TODO: implement initState

    setState(() {});
    super.initState();
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
                  for (var playerMatchPoints in widget.playerMatchPoints)

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
                      ),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
