import 'dart:io';

import 'package:Euro_prediction/screens/match_predict_screen.dart';
import 'package:Euro_prediction/screens/show_predictions_screen.dart';
import 'package:Euro_prediction/screens/show_points_screen.dart';
import 'package:flutter/material.dart';
import 'package:Euro_prediction/components/rounded_button.dart';
import 'package:Euro_prediction/display/predictions_display.dart';
import 'package:Euro_prediction/functions/calculate_write_points.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

List<PredictionsDisplay> predictions = [];
List<PlayerMatchPoints> playerMatchPointsList = [];
final _firestore = FirebaseFirestore.instance;
int matchNum;
String playerId;
String matchResult;
String manOfMatch;
String bestAttacker;
String bestDefender;

class MatchDisplay extends StatelessWidget {
  MatchDisplay(
      {@required this.matchNum,
      @required this.firstTeam,
      @required this.secondTeam,
      @required this.firstImg,
      @required this.secondImg,
      @required this.cutOffTime,
      this.matchStatus,
      @required this.buttonName});

  final int matchNum;
  final String firstTeam;
  final String secondTeam;
  final String firstImg;
  final String secondImg;
  final String cutOffTime;
  final String matchStatus;
  final String buttonName;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Color(0xFF1D1E33),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            'MATCH #$matchNum',
            style: TextStyle(
              color: Colors.white,
              fontSize: 50.0,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.start,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CircleAvatar(
                radius: 100.0,
                backgroundImage: AssetImage(firstImg),
              ),
              Text(
                'V/S',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              CircleAvatar(
                radius: 100.0,
                backgroundImage: AssetImage(secondImg),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(firstTeam + ' v/s ',
                  style: TextStyle(
                      fontFamily: 'SourceSansPro',
                      fontSize: 40.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              Text(secondTeam,
                  style: TextStyle(
                      fontFamily: 'SourceSansPro',
                      fontSize: 40.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          PredictButton(
              title: buttonName,
              colour: Colors.blue[900],
              onPressed: () {
                if (buttonName == 'PREDICT NOW') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MatchPredictScreen(
                              matchNum: matchNum,
                              firstTeam: firstTeam,
                              secondTeam: secondTeam,
                              firstImg: firstImg,
                              secondImg: secondImg)));
                }
                if (buttonName == 'SHOW PREDICTIONS') {
                  getPredictions(matchNum);
                  sleep(Duration(milliseconds: 1000));
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ShowPredictionsScreen(
                              matchNum: matchNum,
                              firstTeam: firstTeam,
                              secondTeam: secondTeam,
                              firstImg: firstImg,
                              secondImg: secondImg,
                              predictions: predictions)));
                }
                if (buttonName == 'SHOW RESULTS') {
                  getPlayerMatchPoints(matchNum);
                  sleep(Duration(milliseconds: 1000));
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ShowPointsScreen(
                              matchNum: matchNum,
                              playerMatchPoints: playerMatchPointsList)));
                }
              }),
          Text('Cut off time ends in : $cutOffTime',
              style: TextStyle(
                  fontFamily: 'SourceSansPro',
                  fontSize: 40.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

void getPredictions(int matchNumber) async {
  final matchPrediction = await _firestore
      .collection('matchprediction')
      .where("matchnum", isEqualTo: matchNumber)
      .get();

  predictions.clear();
  for (var match in matchPrediction.docs) {
    matchNum = match.data()['matchnum'];
    playerId = match.data()['playerid'];
    matchResult = match.data()['matchresult'];
    manOfMatch = match.data()['manofmatch'];
    bestAttacker = match.data()['bestattacker'];
    bestDefender = match.data()['bestdefender'];

    final predictionDisplay = PredictionsDisplay(
      playerId: playerId,
      matchNum: matchNum.toString(),
      matchResult: matchResult,
      manOfMatch: manOfMatch,
      bestAttacker: bestAttacker,
      bestDefender: bestDefender,
    );
    predictions.add(predictionDisplay);
  }
}

void getPlayerMatchPoints(int matchNumber) async {
  int playerResultPoints;
  int playerMomPoints;
  int playerAttackerPoints;
  int playerDefenderPoints;

  print ('in getPlayerMatchPoints');

  final matchPoints = await _firestore
      .collection('matchpoints')
      .where("matchnum", isEqualTo: matchNumber)
      .get();

  playerMatchPointsList.clear();
  for (var match in matchPoints.docs) {
    matchNum = match.data()['matchnum'];
    playerId = match.data()['playerId'];
    playerResultPoints = match.data()['resultpoints'];
    playerMomPoints = match.data()['mompoints'];
    playerAttackerPoints = match.data()['attackerpoints'];
    playerDefenderPoints = match.data()['defenderpoints'];

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
}
